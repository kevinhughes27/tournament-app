require 'test_helper'

class DivisionUpdateTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @division = divisions(:open)
  end

  test "updating the bracket_type clears the previous games" do
    division = create_division(bracket_type: 'single_elimination_8')
    assert_equal 12, division.games.count

    DivisionUpdate.perform(division, bracket_type: 'single_elimination_4')

    assert_equal 4, division.games.count
  end

  test "updating the bracket_type resets seeded status" do
    division = create_division(bracket_type: 'single_elimination_8')
    @teams.update_all(division_id: division.id)

    SeedDivision.perform(division)

    assert division.seeded?

    DivisionUpdate.perform(division, bracket_type: 'single_elimination_4')

    refute division.seeded?
  end

  test "updating the bracket_type clears the previous places" do
    division = create_division(bracket_type: 'single_elimination_8')
    assert_equal 12, division.games.count

    DivisionUpdate.perform(division, bracket_type: 'single_elimination_4')

    assert_equal 4, division.games.count
  end
end
