require 'test_helper'

module Divisions
  class ResetRoundJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
    end

    test "reset a round" do
      division = new_division('single_elimination_8')
      ResetRoundJob.perform_now(division: division, round: 1)
    end

    private

    def new_division(type)
      perform_enqueued_jobs do
        division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)
      end
    end
  end
end
