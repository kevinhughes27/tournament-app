require 'test_helper'

module Divisions
  class UpdatePoolJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @division = divisions(:open)
      @teams = @division.teams.order(:seed)
    end

    test "pool not finished" do
      division = new_division('USAU 8.1')
      @teams.update_all(division_id: division.id)

      Game.any_instance.expects(:save!).never
      UpdatePoolJob.perform_now(division: division, pool: 'A')
    end

    test "records pool results" do
      division = new_division('USAU 8.1')
      teams = @teams.to_a
      @teams.update_all(division_id: division.id)
      division.seed

      play_pool(@teams, division, 'A')

      assert_difference 'PoolResult.count', +4 do
        UpdatePoolJob.perform_now(division: division, pool: 'A')
      end
    end

    test "update pool" do
      division = new_division('USAU 8.1')
      teams = @teams.to_a
      @teams.update_all(division_id: division.id)
      division.seed

      play_pool(@teams, division, 'A')

      UpdatePoolJob.perform_now(division: division, pool: 'A')

      game1 = division.games.find_by(home_prereq_uid: 'A1')
      game2 = division.games.find_by(away_prereq_uid: 'A4')

      assert_equal teams.last, game1.home
      assert_equal teams.first, game2.away
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
        UpdatePoolJob.perform_now(division: division, pool: 'A')
        assert_equal teams.last, game1.reload.home
        assert_equal teams.first, game2.reload.away
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
        UpdatePoolJob.perform_now(division: division, pool: 'A')
        refute game1.reload.confirmed?
        refute game2.reload.confirmed?
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
