require 'test_helper'

class DivisionUpdateTest < ActiveSupport::TestCase
  setup do
    @tournament = FactoryGirl.create(:tournament)
  end

  test "updating the bracket_type clears the previous games" do
    division = DivisionCreate.perform(@tournament,
      FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    )
    assert_equal 12, division.games.count

    DivisionUpdate.perform(division, bracket_type: 'single_elimination_4')

    assert_equal 4, division.games.count
  end

  test "updating the bracket_type resets seeded status" do
    division = DivisionCreate.perform(@tournament,
      FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    )

    teams = (1..8).map do |seed|
      FactoryGirl.create(:team, division: division, seed: seed)
    end

    SeedDivision.perform(division: division)

    assert division.seeded?

    DivisionUpdate.perform(division, bracket_type: 'single_elimination_4')

    refute division.seeded?
  end

  test "updating the bracket_type clears the previous places" do
    division = DivisionCreate.perform(@tournament,
      FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    )
    assert_equal 8, division.places.count

    DivisionUpdate.perform(division, bracket_type: 'single_elimination_4')

    assert_equal 4, division.places.count
  end
end
