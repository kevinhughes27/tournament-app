require 'test_helper'

class UpdateGameScoreTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @user = users(:bob)
    @division = divisions(:open)
    @home = teams(:swift)
    @away = teams(:goose)
    @game = games(:swift_goose)
  end

  test "can't update score unless teams" do
    game = games(:semi_final)
    refute game.teams_present?

    update = UpdateGameScore.new(game: game, user: @user, home_score: 10, away_score: 5)
    update.perform

    assert update.halted?
    assert_nil game.score
  end

  test "can't update score if not safe" do
    SafeToUpdateScoreCheck.expects(:perform).returns(false)
    SetGameScore.expects(:perform).never
    AdjustGameScore.expects(:perform).never

    update = UpdateGameScore.new(game: @game, user: @user, home_score: 14, away_score: 12)
    update.perform

    assert update.halted?
  end

  test "force unsafe update" do
    update = UpdateGameScore.new(game: @game, user: @user, home_score: 14, away_score: 12, force: true)
    update.perform
    @game.reload

    assert update.succeeded?
    assert_equal 14, @game.home_score
    assert_equal 12, @game.away_score
  end

  test "sets the score if no previous score" do
    @game.reset_score! && @game.save!
    SetGameScore.expects(:perform)
    UpdateGameScore.perform(game: @game, user: @user, home_score: 15, away_score: 11)
  end

  test "adjusts the score if game already has a score" do
    AdjustGameScore.expects(:perform)
    UpdateGameScore.perform(game: @game, user: @user, home_score: 14, away_score: 12)
  end

  test "confirms the game" do
    UpdateGameScore.perform(game: @game, user: @user, home_score: 15, away_score: 11)
    assert @game.confirmed?
  end

  test "creates ScoreEntry" do
    assert_difference "ScoreEntry.count", +1 do
      UpdateGameScore.perform(game: @game, user: @user, home_score: 15, away_score: 11)
    end
  end

  test "resolves any disputes" do
    dispute = ScoreDispute.create!(
      tournament: @tournament,
      game: @game
    )

    UpdateGameScore.perform(game: @game, user: @user, home_score: 15, away_score: 11, resolve: true)

    assert_equal 'resolved', dispute.reload.status
  end

  test "updates the pool for pool game" do
    @game.update_columns(
      pool: 'A',
      home_pool_seed: 1,
      away_pool_seed: 2
    )
    SafeToUpdateScoreCheck.expects(:perform).returns(true)
    FinishPoolJob.expects(:perform_later)
    UpdateGameScore.perform(game: @game, user: @user, home_score: 15, away_score: 11)
  end

  test "doesn't update the bracket for bracket game if winner is the same" do
    Divisions::AdvanceBracketJob.expects(:perform_later).never
    UpdateGameScore.perform(game: @game, user: @user, home_score: 15, away_score: 11)
  end

  test "updates the bracket for bracket game if no existing score" do
    @game.reset_score! && @game.save!
    Divisions::AdvanceBracketJob.expects(:perform_later)
    UpdateGameScore.perform(game: @game, user: @user, home_score: 15, away_score: 11)
  end

  test "updates the bracket for bracket game if winner changes" do
    Divisions::AdvanceBracketJob.expects(:perform_later)
    UpdateGameScore.perform(game: @game, user: @user, home_score: 11, away_score: 15)
  end

  test "updates the places for bracket_game" do
    Divisions::UpdatePlacesJob.expects(:perform_later)
    UpdateGameScore.perform(game: @game, user: @user, home_score: 15, away_score: 11)
  end
end
