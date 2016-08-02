require 'test_helper'

module Games
  class AdjustScoreJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @division = divisions(:open)
      @home = teams(:swift)
      @away = teams(:goose)
      @game = games(:swift_goose)
    end

    test "updates the teams wins and points_for" do
      home_wins = @home.wins
      away_wins = @away.wins
      home_pts_for = @home.points_for
      away_pts_for = @away.points_for
      home_score = @game.home_score
      away_score = @game.away_score

      @game.stubs(:update_bracket)
      AdjustScoreJob.perform_now(game: @game, home_score: 14, away_score: 12)

      @home.reload
      @away.reload

      assert_equal home_wins, @home.wins
      assert_equal away_wins, @away.wins
      assert_equal home_pts_for + 14 - home_score, @home.points_for
      assert_equal away_pts_for + 12 - away_score, @away.points_for
    end

    test "can flip the winner" do
      game = Game.create(
        tournament: @tournament,
        division: @division,
        bracket_uid: 'q1',
        round: 1,
        home_prereq: '1',
        away_prereq: '2',
        home: @home,
        away: @away
      )

      home_wins = @home.wins
      home_pts_for = @home.points_for
      away_wins = @away.wins
      away_pts_for = @away.points_for

      game.stubs(:update_bracket)
      SetScoreJob.perform_now(game: game, home_score: 15, away_score: 11)
      AdjustScoreJob.perform_now(game: game, home_score: 10, away_score: 13)

      @home.reload
      @away.reload

      assert_equal home_wins, @home.wins
      assert_equal away_wins+1, @away.wins
      assert_equal home_pts_for + 10, @home.points_for
      assert_equal away_pts_for + 13, @away.points_for
    end
  end
end
