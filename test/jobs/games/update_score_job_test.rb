require 'test_helper'

module Games
  class UpdateScoreJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @division = divisions(:open)
      @home = teams(:swift)
      @away = teams(:goose)
      @game = games(:swift_goose)
    end

    test "can't update score unless teams" do
      game = games(:semi_final)
      refute game.teams_present?
      refute UpdateScoreJob.perform_now(game: game, home_score: 10, away_score: 5)
      assert_nil game.score
    end

    test "can't update score if not safe" do
      SafeToUpdateScoreJob.expects(:perform_now).returns(false)
      SetScoreJob.expects(:perform_now).never
      AdjustScoreJob.expects(:perform_now).never
      refute UpdateScoreJob.perform_now(game: @game, home_score: 14, away_score: 12)
    end

    test "sets the score if no previous score" do
      @game.reset_score! && @game.save!
      SetScoreJob.expects(:perform_now)
      UpdateScoreJob.perform_now(game: @game, home_score: 15, away_score: 11)
    end

    test "adjusts the score if game already has a score" do
      AdjustScoreJob.expects(:perform_now)
      UpdateScoreJob.perform_now(game: @game, home_score: 14, away_score: 12)
    end

    test "confirms the game" do
      UpdateScoreJob.perform_now(game: @game, home_score: 15, away_score: 11)
      assert @game.confirmed?
    end

    test "updates the pool for pool game" do
      @game.update_column(:pool, 'A')
      SafeToUpdateScoreJob.expects(:perform_now).returns(true)
      Divisions::FinishPoolJob.expects(:perform_later)
      UpdateScoreJob.perform_now(game: @game, home_score: 15, away_score: 11)
    end

    test "doesn't update the bracket for bracket game if winner is the same" do
      Divisions::AdvanceBracketJob.expects(:perform_later).never
      UpdateScoreJob.perform_now(game: @game, home_score: 15, away_score: 11)
    end

    test "updates the bracket for bracket game if no existing score" do
      @game.reset_score! && @game.save!
      Divisions::AdvanceBracketJob.expects(:perform_later)
      UpdateScoreJob.perform_now(game: @game, home_score: 15, away_score: 11)
    end

    test "updates the bracket for bracket game if winner changes" do
      Divisions::AdvanceBracketJob.expects(:perform_later)
      UpdateScoreJob.perform_now(game: @game, home_score: 11, away_score: 15)
    end

    test "updates the places for bracket_game" do
      Divisions::UpdatePlacesJob.expects(:perform_later)
      UpdateScoreJob.perform_now(game: @game, home_score: 15, away_score: 11)
    end
  end
end
