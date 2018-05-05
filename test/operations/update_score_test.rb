require 'test_helper'

class UpdateScoreTest < OperationTest
  test "updates the pool for pool game" do
    game = FactoryGirl.create(:pool_game)
    FinishPoolJob.expects(:perform_later)
    UpdateScore.perform(game: game, home_score: 15, away_score: 11)
  end

  test "updates the bracket for bracket game if no existing score" do
    game = FactoryGirl.create(:game)
    AdvanceBracketJob.expects(:perform_later)
    UpdateScore.perform(game: game, home_score: 15, away_score: 11)
  end

  test "doesn't update the bracket for bracket game if winner is the same" do
    game = FactoryGirl.create(:game, :finished)
    AdvanceBracketJob.expects(:perform_later).never
    UpdateScore.perform(game: game, home_score: game.home_score + 1, away_score: game.away_score + 1)
  end

  test "updates the bracket for bracket game if winner changes" do
    game = FactoryGirl.create(:game, :finished)
    AdvanceBracketJob.expects(:perform_later)
    UpdateScore.perform(game: game, home_score: game.away_score, away_score: game.home_score)
  end

  test "updates the places for bracket_game" do
    game = FactoryGirl.create(:game)
    UpdatePlacesJob.expects(:perform_later)
    UpdateScore.perform(game: game, home_score: 15, away_score: 11)
  end

  test "updating scores broadcasts changes" do
    game = FactoryGirl.create(:game)
    ActionCable.server.expects(:broadcast)
    UpdateScore.perform(game: game, home_score: 15, away_score: 13)
  end
end
