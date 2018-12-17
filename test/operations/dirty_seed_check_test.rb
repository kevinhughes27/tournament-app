require 'test_helper'

class DirtySeedCheckTest < OperationTest
  test "perform" do
    params = FactoryBot.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(params)
    seeds = create_seeds(division, 8)

    refute division.seeded?
    assert DirtySeedCheck.perform(division)

    seed_division(division)

    assert division.seeded?
    refute DirtySeedCheck.perform(division)

    division.seeds[0].update(rank: 2)
    division.seeds[1].update(rank: 1)

    assert DirtySeedCheck.perform(division)
  end

  test "perform with pool" do
    params = FactoryBot.attributes_for(:division, bracket_type: 'USAU 8.1')
    division = create_division(params)
    seeds = create_seeds(division, 8)

    refute division.seeded?
    assert DirtySeedCheck.perform(division)

    seed_division(division)

    assert division.seeded?
    refute DirtySeedCheck.perform(division)

    division.seeds[0].update(rank: 2)
    division.seeds[1].update(rank: 1)

    assert DirtySeedCheck.perform(division)
  end

  private

  def create_division(params)
    input = params.except(:tournament)
    execute_graphql("createDivision", "CreateDivisionInput", input)
    Division.last
  end

  def create_seeds(division, num)
    (1..num).map do |rank|
      FactoryBot.create(:seed, division: division, rank: rank)
    end
  end

  def seed_division(division)
    execute_graphql("seedDivision", "SeedDivisionInput", {division_id: division.id})
    division.reload
  end
end
