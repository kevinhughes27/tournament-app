require 'test_helper'

class GameUpdateScoreTest < ActiveSupport::TestCase
  setup do
    @user = FactoryGirl.create(:user)
  end

  test "can't update score unless teams" do
    game = FactoryGirl.create(:game, home: nil, away: nil)

    update = GameUpdateScore.new(game: game, user: @user, home_score: 10, away_score: 5)
    update.perform

    assert update.failed?
    assert_nil game.home_score
    assert_nil game.away_score
  end

  test "can't submit a tie for a bracket game" do
    game = FactoryGirl.create(:game)

    update = GameUpdateScore.new(game: game, user: @user, home_score: 5, away_score: 5)
    update.perform

    assert update.failed?
  end

  test "can submit a tie for a pool game" do
    game = FactoryGirl.create(:pool_game)

    update = GameUpdateScore.new(game: game, user: @user, home_score: 5, away_score: 5)
    update.perform

    assert update.succeeded?
    assert_equal 5, game.home_score
    assert_equal 5, game.away_score
  end

  test "can't update score if not safe" do
    game = FactoryGirl.create(:game)
    SafeToUpdateScoreCheck.expects(:perform).returns(false)

    update = GameUpdateScore.new(game: game, user: @user, home_score: 14, away_score: 12)
    update.perform

    assert update.failed?
  end

  test "force unsafe update" do
    game = FactoryGirl.create(:game)
    SafeToUpdateScoreCheck.expects(:perform).never

    update = GameUpdateScore.new(game: game, user: @user, home_score: 14, away_score: 12, force: true)
    update.perform

    assert update.succeeded?
    assert_equal 14, game.home_score
    assert_equal 12, game.away_score
  end

  test "confirms the game" do
    game = FactoryGirl.create(:game)
    GameUpdateScore.perform(game: game, user: @user, home_score: 15, away_score: 11)
    assert game.confirmed?
  end

  test "creates ScoreEntry" do
    game = FactoryGirl.create(:game)
    assert_difference "ScoreEntry.count", +1 do
      GameUpdateScore.perform(game: game, user: @user, home_score: 15, away_score: 11)
    end
  end

  test "resolves any disputes" do
    game = FactoryGirl.create(:game)
    dispute = ScoreDispute.create!(tournament: game.tournament, game: game)
    game.reload

    GameUpdateScore.perform(game: game, user: @user, home_score: 15, away_score: 11, resolve: true)

    assert_equal 'resolved', dispute.reload.status
  end

  test "updates the pool for pool game" do
    game = FactoryGirl.create(:pool_game)
    FinishPoolJob.expects(:perform_later)
    GameUpdateScore.perform(game: game, user: @user, home_score: 15, away_score: 11)
  end

  test "updates the bracket for bracket game if no existing score" do
    game = FactoryGirl.create(:game)
    AdvanceBracketJob.expects(:perform_later)
    GameUpdateScore.perform(game: game, user: @user, home_score: 15, away_score: 11)
  end

  test "doesn't update the bracket for bracket game if winner is the same" do
    game = FactoryGirl.create(:game, :finished)
    AdvanceBracketJob.expects(:perform_later).never
    GameUpdateScore.perform(
      game: game,
      user: @user,
      home_score: game.home_score + 1,
      away_score: game.away_score + 1
    )
  end

  test "updates the bracket for bracket game if winner changes" do
    game = FactoryGirl.create(:game, :finished)
    AdvanceBracketJob.expects(:perform_later)
    GameUpdateScore.perform(
      game: game,
      user: @user,
      home_score: game.away_score,
      away_score: game.home_score
    )
  end

  test "updates the places for bracket_game" do
    game = FactoryGirl.create(:game)
    UpdatePlacesJob.expects(:perform_later)
    GameUpdateScore.perform(game: game, user: @user, home_score: 15, away_score: 11)
  end
end
