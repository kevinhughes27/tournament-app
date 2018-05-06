require 'test_helper'

class SetTeamsDivisionTest < OperationTest
  setup do
    @division = FactoryGirl.create(:division)
  end

  test "assigns teams to divisions" do
    team = FactoryGirl.create(:team)
    new_division = FactoryGirl.create(:division)

    action = SetTeamsDivision.new(
      @tournament,
      ids: [team.id],
      arg: new_division.name
    )
    action.perform

    assert action.succeeded?
    assert_equal new_division, team.reload.division
  end

  test "fails if it is not safe to change divisions" do
    team = FactoryGirl.create(:team)
    new_division = FactoryGirl.create(:division)
    FactoryGirl.create(:game, :finished, home: team)

    action = SetTeamsDivision.new(
      @tournament,
      ids: [team.id],
      arg: new_division.name
    )
    action.perform

    refute action.succeeded?
    assert_equal 'Cancelled: not all teams could be updated safely', action.output
  end
end
