require 'test_helper'

module Divisions
  class UpdatePoolJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @teams = @tournament.teams.order(:seed)
    end

    test "pool not finished" do
      division = new_division('USAU 8.1')
      @teams.update_all(division_id: division.id)

      Game.any_instance.expects(:save!).never
      UpdatePoolJob.perform_now(division: division, pool: 'A')
    end

    test "update pool" do
      division = new_division('USAU 8.1')
      @teams.update_all(division_id: division.id)
      division.seed

      # sort by wins is reverse of sort by seed now
      @teams.each_with_index do |team, idx|
        team.update_column(:wins, idx)
      end

      # confirm games
      division.games.where(pool: 'A').update_all(score_confirmed: true)

      UpdatePoolJob.perform_now(division: division, pool: 'A')

      game1 = division.games.find_by(home_prereq_uid: 'A1')
      game2 = division.games.find_by(away_prereq_uid: 'A4')

      assert_equal @teams.last, game1.home
      assert_equal @teams.first, game2.away
    end

    private

    def new_division(type)
      perform_enqueued_jobs do
        division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)
      end
    end
  end
end
