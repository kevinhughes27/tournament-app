require 'test_helper'

class DirtySeedCheckTest < ActiveSupport::TestCase
  setup do
    @tournament = FactoryGirl.create(:tournament)
  end

  test "perform" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(@tournament, params)

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
    params = FactoryGirl.attributes_for(:division, bracket_type: 'USAU 8.1')
    division = create_division(@tournament, params)

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

  def create_division(tournament, params)
    DivisionCreate.perform(tournament: tournament, division_params: params)
  end

  def seed_division(division)
    DivisionSeed.perform(division: division)
  end
end
