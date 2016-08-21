require 'test_helper'

class DirtySeedCheckTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @tournament = tournaments(:noborders)
    @division = divisions(:open)
    @teams = @division.teams.order(:seed)
  end

  test "perform" do
    division = new_division('single_elimination_8')
    @teams.update_all(division_id: division.id)

    refute division.seeded?
    assert DirtySeedCheck.perform(division)

    SeedDivision.perform(division)

    assert division.seeded?
    refute DirtySeedCheck.perform(division)

    division.teams[0].update(seed: 2)
    division.teams[1].update(seed: 1)

    assert DirtySeedCheck.perform(division)
  end

  test "perform with pool" do
    division = new_division('USAU 8.1')
    @teams.update_all(division_id: division.id)

    refute division.seeded?
    assert DirtySeedCheck.perform(division)

    SeedDivision.perform(division)

    assert division.seeded?
    refute DirtySeedCheck.perform(division)

    division.teams[0].update(seed: 2)
    division.teams[1].update(seed: 1)

    assert DirtySeedCheck.perform(division)
  end

  private

  def new_division(type)
    perform_enqueued_jobs do
      division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)
    end
  end
end
