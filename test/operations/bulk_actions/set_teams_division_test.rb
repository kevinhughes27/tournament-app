require 'test_helper'

module BulkActions
  class SetTeamsDivisionTest < ActiveSupport::TestCase
    setup do
      @tournament = FactoryGirl.create(:tournament)
      @division = FactoryGirl.create(:division)
    end

    test "assigns teams to divisions" do
      team = FactoryGirl.create(:team)
      new_division = FactoryGirl.create(:division)

      action = SetTeamsDivision.new(
        tournament_id: @tournament.id,
        ids: [team.id],
        arg: new_division.name
      )
      action.perform

      assert_equal 200, action.status
      json = JSON.parse(action.response)
      assert_equal team.name, json.first["name"]
      assert_equal new_division.name, json.first["division"]
      assert_equal new_division, team.reload.division
    end

    test "fails if it is not safe to change divisions" do
      team = FactoryGirl.create(:team)
      new_division = FactoryGirl.create(:division)
      FactoryGirl.create(:game, :finished, home: team)

      action = SetTeamsDivision.new(
        tournament_id: @tournament.id,
        ids: [team.id],
        arg: new_division.name
      )
      action.perform

      assert_equal 422, action.status
      assert_equal 'Cancelled: not all teams could be updated safely', action.response[:message]
      refute_equal new_division, team.reload.division
    end
  end
end
