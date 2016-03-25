require 'test_helper'

module BulkActions
  class TeamsSetDivisionJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @team = teams(:swift)
      @division = divisions(:women)
    end

    test "assigns teams to divisions" do
      response = TeamsSetDivisionJob.perform_now(
        ids: [@team.id],
        arg: @division.name
      )

      assert_equal @division, @team.reload.division
    end
  end
end
