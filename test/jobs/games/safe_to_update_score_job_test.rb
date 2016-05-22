require 'test_helper'

module Games
  class SafeToUpdateScoreJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @division = divisions(:open)
      @home = teams(:swift)
      @away = teams(:goose)
      @game = games(:swift_goose)
    end

    test "unsafe if winner changes and pool is already finished" do
      @game.update_column(:pool, 'A')

      assert @game.division.games.where(pool: 'A').all? { |g| g.confirmed? },
             'all pool games need to be confirmed for this test to be correct'

      assert Games::SafeToUpdateScoreJob.perform_now(
        game: @game,
        home_score: @game.home_score,
        away_score: @game.away_score
      ), 'expected update to be safe'

      refute Games::SafeToUpdateScoreJob.perform_now(
        game: @game,
        home_score: @game.away_score,
        away_score: @game.home_score
      ), 'expected update to be unsafe'
    end

    test "safe if pool is already finished but winner doesn't change" do
      @game.update_column(:pool, 'A')

      assert Games::SafeToUpdateScoreJob.perform_now(
        game: @game,
        home_score: @game.home_score,
        away_score: @game.away_score
      ), 'expected update to be safe'
    end

    test "safe if winner changes and pool is already finished but bracket hasn't started" do
      @game.update_columns(pool: 'A', round: nil)
      games(:pheonix_mavericks).update_column(:score_confirmed, false)

      assert Games::SafeToUpdateScoreJob.perform_now(
        game: @game,
        home_score: @game.away_score,
        away_score: @game.home_score
      ), 'expected update to be safe'
    end

    test "unsafe if dependent games are scored" do
      game1 = Game.create!(
        tournament: @tournament,
        division: @division,
        bracket_uid: 'q1',
        home_prereq_uid: '1',
        away_prereq_uid: '2',
        home: @home,
        away: @away,
        home_score: 15,
        away_score: 11,
        score_confirmed: true
      )

      game2 = Game.create!(
        tournament: @tournament,
        division: @division,
        bracket_uid: 's1',
        home_prereq_uid: 'Wq1',
        away_prereq_uid: 'Wq2'
      )

      assert Games::SafeToUpdateScoreJob.perform_now(
        game: game1,
        home_score: game1.away_score,
        away_score: game1.home_score
      ), 'expected update to be safe'

      game2.update_column(:score_confirmed, true)

      refute Games::SafeToUpdateScoreJob.perform_now(
        game: game1,
        home_score: game1.away_score,
        away_score: game1.home_score
      ), 'expected update to be unsafe'
    end

    test "safe if winner doesn't change but dependent games are scored" do
      game1 = Game.create!(
        tournament: @tournament,
        division: @division,
        bracket_uid: 'q1',
        home_prereq_uid: '1',
        away_prereq_uid: '2',
        home: @home,
        away: @away,
        home_score: 15,
        away_score: 11,
      )

      game2 = Game.create!(
        tournament: @tournament,
        division: @division,
        bracket_uid: 's1',
        home_prereq_uid: 'Wq1',
        away_prereq_uid: 'Wq2'
      )

      assert Games::SafeToUpdateScoreJob.perform_now(
        game: game1,
        home_score: game1.home_score,
        away_score: game1.away_score
      ), 'expected update to be safe'

      game2.update_column(:score_confirmed, true)

      assert Games::SafeToUpdateScoreJob.perform_now(
        game: game1,
        home_score: game1.home_score,
        away_score: game1.away_score
      ), 'expected update to be safe'
    end
  end
end
