require 'test_helper'

class SaveScoreTest < OperationTest
  test "updates the pool for pool game" do
    game = FactoryBot.create(:pool_game)
    FinishPoolJob.expects(:perform_later)
    SaveScore.perform(game: game, home_score: 15, away_score: 11)
  end

  test "updates the bracket for bracket game if no existing score" do
    game = FactoryBot.create(:game)
    AdvanceBracketJob.expects(:perform_later)
    SaveScore.perform(game: game, home_score: 15, away_score: 11)
  end

  test "doesn't update the bracket for bracket game if winner is the same" do
    game = FactoryBot.create(:game, :finished)
    AdvanceBracketJob.expects(:perform_later).never
    SaveScore.perform(game: game, home_score: game.home_score + 1, away_score: game.away_score + 1)
  end

  test "updates the bracket for bracket game if winner changes" do
    game = FactoryBot.create(:game, :finished)
    AdvanceBracketJob.expects(:perform_later)
    SaveScore.perform(game: game, home_score: game.away_score, away_score: game.home_score)
  end

  test "updates the places for bracket_game" do
    game = FactoryBot.create(:game)
    UpdatePlacesJob.expects(:perform_later)
    SaveScore.perform(game: game, home_score: 15, away_score: 11)
  end

  test "updating scores broadcasts changes" do
    game = FactoryBot.create(:game)
    ActionCable.server.expects(:broadcast)
    SaveScore.perform(game: game, home_score: 15, away_score: 13)
  end
end
