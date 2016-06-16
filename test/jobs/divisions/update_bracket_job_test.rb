require 'test_helper'

module Divisions
  class UpdateBracketJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @division = divisions(:open)
      @home = teams(:swift)
      @away = teams(:goose)
    end

    test "pushes winner through the bracket" do
      game1 = Game.create!(
        tournament: @tournament,
        division: @division,
        round: 1,
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
        round: 2,
        bracket_uid: 's1',
        home_prereq_uid: 'Wq1',
        away_prereq_uid: 'Wq2'
      )

      perform_enqueued_jobs do
        UpdateBracketJob.perform_now(game_id: game1.id)
        assert_equal @home, game2.reload.home
      end
    end

    test "pushes loser through the bracket" do
      game1 = Game.create!(
        tournament: @tournament,
        division: @division,
        round: 1,
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
        round: 2,
        bracket_uid: 'c1',
        home_prereq_uid: 'Lq2',
        away_prereq_uid: 'Lq1'
      )

      perform_enqueued_jobs do
        UpdateBracketJob.perform_now(game_id: game1.id)
        assert_equal @away, game2.reload.away
      end
    end

    test "resets dependent_games if required" do
      game1 = Game.create!(
        tournament: @tournament,
        division: @division,
        round: 1,
        bracket_uid: 'q1',
        home_prereq_uid: '1',
        away_prereq_uid: '2',
        home: @home,
        away: @away,
        home_score: 11,
        away_score: 15,
        score_confirmed: true
      )

      game2 = Game.create!(
        tournament: @tournament,
        division: @division,
        round: 2,
        bracket_uid: 's1',
        home_prereq_uid: 'Wq1',
        away_prereq_uid: 'Wq2',
        home: @home,
        score_confirmed: true
      )

      perform_enqueued_jobs do
        UpdateBracketJob.perform_now(game_id: game1.id)
        assert_equal @away, game2.reload.home
        refute game2.confirmed?
      end
    end

    test "resets future games as required (recursive reset)" do
      game1 = Game.create!(
        tournament: @tournament,
        division: @division,
        round: 1,
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
        round: 2,
        bracket_uid: 's1',
        home_prereq_uid: 'Wq1',
        away_prereq_uid: 'Wq2',
        home: @home,
        score_confirmed: true
      )

      game3 = Game.create!(
        tournament: @tournament,
        division: @division,
        round: 3,
        bracket_uid: 'f1',
        home_prereq_uid: 'Ws1',
        away_prereq_uid: 'Ws2',
        home: @home,
        score_confirmed: true
      )

      perform_enqueued_jobs do
        UpdateBracketJob.perform_now(game_id: game1.id)
        refute game2.reload.confirmed?
        assert_nil game3.reload.home
      end
    end
  end
end
