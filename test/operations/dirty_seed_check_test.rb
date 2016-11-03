require 'test_helper'

class DirtySeedCheckTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @tournament = tournaments(:noborders)
    @division = divisions(:open)
    @teams = @division.teams.order(:seed)
  end

  test "perform" do
    division = create_division(bracket_type: 'single_elimination_8')
    @teams.update_all(division_id: division.id)

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
    division = create_division(bracket_type: 'USAU 8.1')
    @teams.update_all(division_id: division.id)

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
