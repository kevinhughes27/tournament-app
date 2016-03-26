require 'test_helper'

module BulkActions
  class TeamsSetDivisionJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)

      @division = divisions(:women)
    end

    test "assigns teams to divisions" do
      team = teams(:the_forgotten)

      response, status = TeamsSetDivisionJob.perform_now(
        ids: [team.id],
        arg: @division.name
      )

      assert_equal 200, status
      json = JSON.parse(response)
      assert_equal team.name, json.first["name"]
      assert_equal @division, team.reload.division
    end

    test "fails if it is not safe to change divisions" do
      team = teams(:swift)

      response, status = TeamsSetDivisionJob.perform_now(
        ids: [team.id],
        arg: @division.name
      )

      assert_equal 422, status
      assert_equal 'Cancelled: not all teams could be update safely', response[:message]
      refute_equal @division, team.reload.division
    end
  end
end
