require 'test_helper'

class DirtySeedCheckTest < ActiveSupport::TestCase
  setup do
    @tournament = FactoryGirl.create(:tournament)
  end

  test "perform" do
    division = DivisionCreate.perform(@tournament,
      FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    )

    teams = (1..8).map do |seed|
      FactoryGirl.create(:team, division: division, seed: seed)
    end

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
    division = DivisionCreate.perform(@tournament,
      FactoryGirl.attributes_for(:division, bracket_type: 'USAU 8.1')
    )

    teams = (1..8).map do |seed|
      FactoryGirl.create(:team, division: division, seed: seed)
    end

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

  def seed_division(division)
    SeedDivision.perform(division: division)
  end
end
