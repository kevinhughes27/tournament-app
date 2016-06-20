require 'test_helper'

module Games
  class SetScoreJobTest < ActiveJob::TestCase
    setup do
      @home = teams(:swift)
      @away = teams(:goose)
      @game = games(:swift_goose)
      @game.reset! && @game.save!
    end

    test "updates the teams wins and points_for" do
      home_wins = @home.wins
      away_wins = @away.wins
      home_pts_for = @home.points_for
      away_pts_for = @away.points_for

      @game.stubs(:update_bracket)
      SetScoreJob.perform_now(game: @game, home_score: 15, away_score: 11)

      @home.reload
      @away.reload

      assert_equal home_wins+1, @home.wins
      assert_equal away_wins, @away.wins
      assert_equal home_pts_for + 15, @home.points_for
      assert_equal away_pts_for + 11, @away.points_for
    end
  end
end
