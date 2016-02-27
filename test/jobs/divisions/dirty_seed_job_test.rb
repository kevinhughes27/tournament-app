require 'test_helper'

module Divisions
  class DirtySeedJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @teams = @tournament.teams.order(:seed)
    end

    test "perform" do
      division = new_division('single_elimination_8')
      @teams.update_all(division_id: division.id)

      refute division.seeded?
      assert DirtySeedJob.perform_now(division: division)

      division.seed(1)

      assert division.seeded?
      refute DirtySeedJob.perform_now(division: division)

      division.teams[0].update_attributes(seed: 2)
      division.teams[1].update_attributes(seed: 1)

      assert DirtySeedJob.perform_now(division: division)
    end

    private

    def new_division(type)
      perform_enqueued_jobs do
        division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)
      end
    end
  end
end
