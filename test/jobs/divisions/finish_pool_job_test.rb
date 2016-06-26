require 'test_helper'

module Divisions
  class FinishPoolJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @division = divisions(:open)
      @teams = @division.teams.order(:seed)
    end

    test "pool not finished" do
      division = new_division('USAU 8.1')
      @teams.update_all(division_id: division.id)

      Game.any_instance.expects(:save!).never
      FinishPoolJob.perform_now(division: division, pool: 'A')
    end

    test "records pool results" do
      division = new_division('USAU 8.1')
      teams = @teams.to_a
      @teams.update_all(division_id: division.id)
      division.seed

      play_pool(@teams, division, 'A')

      assert_difference 'PoolResult.count', +4 do
        FinishPoolJob.perform_now(division: division, pool: 'A')
      end
    end

    test "clears previous pool results" do
      division = new_division('USAU 8.1')
      teams = @teams.to_a
      @teams.update_all(division_id: division.id)
      division.seed

      play_pool(@teams, division, 'A')

      result = PoolResult.create!(
        tournament_id: @tournament.id,
        division_id: division.id,
        pool: 'A',
        position: 1,
        team: teams.first
      )

      assert_difference 'PoolResult.count', +3 do
        FinishPoolJob.perform_now(division: division, pool: 'A')
      end

      assert_raises ActiveRecord::RecordNotFound do
        result.reload
      end
    end

    test "update pool" do
      division = new_division('USAU 8.1')
      teams = @teams.to_a
      @teams.update_all(division_id: division.id)
      division.seed

      play_pool(@teams, division, 'A')

      FinishPoolJob.perform_now(division: division, pool: 'A')

      game1 = division.games.find_by(home_prereq_uid: 'A1')
      game2 = division.games.find_by(away_prereq_uid: 'A4')

      assert_equal teams.first, game1.home
      assert_equal teams.last, game2.away
    end

    test "update pool using points_for for tie breaker" do
      division = divisions(:open)
      Game.create!(
        tournament_id: @tournament.id,
        division_id: division.id,
        pool: 'A',
        round: 1,
        home_prereq_uid: 1,
        away_prereq_uid: 2,
        home: @teams[0],
        away: @teams[1],
        home_score: 5,
        away_score: 0,
        score_confirmed: true
      )

      Game.create!(
        tournament_id: @tournament.id,
        division_id: division.id,
        pool: 'A',
        round: 1,
        home_prereq_uid: 3,
        away_prereq_uid: 4,
        home: @teams[2],
        away: @teams[3],
        home_score: 10,
        away_score: 2,
        score_confirmed: true
      )

      FinishPoolJob.perform_now(division: division, pool: 'A')
      results = division.pool_results.order(:position)

      assert_equal @teams[2], results[0].team
      assert_equal @teams[0], results[1].team
      assert_equal @teams[3], results[2].team
      assert_equal @teams[1], results[3].team
    end

    test "update pool using points_for for tie breaker with a tie game" do
      division = divisions(:open)
      Game.create!(
        tournament_id: @tournament.id,
        division_id: division.id,
        pool: 'A',
        round: 1,
        home_prereq_uid: 1,
        away_prereq_uid: 2,
        home: @teams[0],
        away: @teams[1],
        home_score: 10,
        away_score: 0,
        score_confirmed: true
      )

      Game.create!(
        tournament_id: @tournament.id,
        division_id: division.id,
        pool: 'A',
        round: 1,
        home_prereq_uid: 3,
        away_prereq_uid: 4,
        home: @teams[2],
        away: @teams[3],
        home_score: 5,
        away_score: 2,
        score_confirmed: true
      )

      Game.create!(
        tournament_id: @tournament.id,
        division_id: division.id,
        pool: 'A',
        round: 1,
        home_prereq_uid: 1,
        away_prereq_uid: 3,
        home: @teams[0],
        away: @teams[2],
        home_score: 10,
        away_score: 10,
        score_confirmed: true
      )

      FinishPoolJob.perform_now(division: division, pool: 'A')
      results = division.pool_results.order(:position)

      assert_equal @teams[0], results[0].team
      assert_equal @teams[2], results[1].team
      assert_equal @teams[3], results[2].team
      assert_equal @teams[1], results[3].team
    end

    test "update pool resets dependent bracket games" do
      division = new_division('USAU 8.1')
      teams = @teams.to_a
      @teams.update_all(division_id: division.id)
      division.seed

      play_pool(@teams, division, 'A')

      game1 = division.games.find_by(home_prereq_uid: 'A1')
      game2 = division.games.find_by(away_prereq_uid: 'A4')

      perform_enqueued_jobs do
        FinishPoolJob.perform_now(division: division, pool: 'A')
        assert_equal teams.first, game1.reload.home
        assert_equal teams.last, game2.reload.away
      end

      game1.update_column(:score_confirmed, true)
      game2.update_column(:score_confirmed, true)

      # reverse wins in the pool
      division.games.where(pool: 'A').each do |game|
        game.update_columns(
          home_score: game.away_score,
          away_score: game.home_score
        )
      end

      division.reload

      perform_enqueued_jobs do
        FinishPoolJob.perform_now(division: division, pool: 'A')
        refute game1.reload.confirmed?
        refute game2.reload.confirmed?
      end
    end

    test "update pool doesn't reset dependent bracket games if no change" do
      division = new_division('USAU 8.1')
      teams = @teams.to_a
      @teams.update_all(division_id: division.id)
      division.seed

      play_pool(@teams, division, 'A')

      game1 = division.games.find_by(home_prereq_uid: 'A1')
      game2 = division.games.find_by(away_prereq_uid: 'A4')

      perform_enqueued_jobs do
        FinishPoolJob.perform_now(division: division, pool: 'A')
        assert_equal teams.first, game1.reload.home
        assert_equal teams.last, game2.reload.away
      end

      game1.update_column(:score_confirmed, true)
      game2.update_column(:score_confirmed, true)

      perform_enqueued_jobs do
        FinishPoolJob.perform_now(division: division, pool: 'A')
        assert game1.reload.confirmed?
        assert game2.reload.confirmed?
      end
    end

    private

    def play_pool(teams, division, pool)
      division.games.where(pool: 'A').each do |game|
        home_score = game.home_id < game.away_id ? 2 : 1
        away_score = game.home_id < game.away_id ? 1 : 2
        game.update_columns(
          home_score: home_score,
          away_score: away_score,
          score_confirmed: true
        )
      end
    end

    def new_division(type)
      perform_enqueued_jobs do
        division = Division.create!(
          tournament: @tournament,
          name: 'New Division',
          bracket_type: type
        )
      end
    end
  end
end
