require 'test_helper'

class DirtySeedCheckTest < OperationTest
  test "perform" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(params)
    teams = create_teams(division, 8)

    refute division.seeded?
    assert DirtySeedCheck.perform(division)

    seed_division(division)

    assert division.seeded?
    refute DirtySeedCheck.perform(division)

    division.teams[0].update(seed: 2)
    division.teams[1].update(seed: 1)

    assert DirtySeedCheck.perform(division)
  end

  test "perform with pool" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'USAU 8.1')
    division = create_division(params)
    teams = create_teams(division, 8)

    refute division.seeded?
    assert DirtySeedCheck.perform(division)

    seed_division(division)

    assert division.seeded?
    refute DirtySeedCheck.perform(division)

    division.teams[0].update(seed: 2)
    division.teams[1].update(seed: 1)

    assert DirtySeedCheck.perform(division)
  end

  private

  def create_division(params)
    input = params.except(:tournament)
    execute_graphql("createDivision", "CreateDivisionInput", input)
    Division.last
  end

  def create_teams(division, num)
    (1..num).map do |seed|
      FactoryGirl.create(:team, division: division, seed: seed)
    end
  end

  def seed_division(division)
    execute_graphql("seedDivision", "SeedDivisionInput", {division_id: division.id})
    division.reload
  end
end
