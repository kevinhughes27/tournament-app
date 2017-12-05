require 'test_helper'

class DivisionUpdateTest < ActiveSupport::TestCase
  setup do
    @tournament = FactoryGirl.create(:tournament)
  end

  test "updating the bracket_type clears the previous games" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(@tournament, params)
    assert_equal 12, division.games.count

    DivisionUpdate.perform(division, bracket_type: 'single_elimination_4')

    assert_equal 4, division.games.count
  end

  test "updating the bracket_type resets seeded status" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(@tournament, params)

    teams = (1..8).map do |seed|
      FactoryGirl.create(:team, division: division, seed: seed)
    end

    SeedDivision.perform(division: division)

    assert division.seeded?

    DivisionUpdate.perform(division, bracket_type: 'single_elimination_4')

    refute division.seeded?
  end

  test "updating the bracket_type clears the previous places" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(@tournament, params)
    assert_equal 8, division.places.count

    DivisionUpdate.perform(division, bracket_type: 'single_elimination_4')

    assert_equal 4, division.places.count
  end

  private

  def create_division(tournament, params)
    DivisionCreate.perform(tournament: tournament, division_params: params)
  end
end
