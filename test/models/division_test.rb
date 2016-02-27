require 'test_helper'

class DivisionTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @teams = @tournament.teams.order(:seed)
    @division = divisions(:open)
  end

  test "division creates all required games" do
    type = 'single_elimination_8'
    assert_difference "Game.count", +12 do
      Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)
    end
  end

  test "division deletes games when it is deleted" do
    type = 'single_elimination_8'
    division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)

    assert_difference "Game.count", -12 do
      division.destroy
    end
  end

  test "division nullifies teams when it is deleted" do
    division = divisions(:open)

    teams = division.teams
    assert teams.present?

    division.destroy

    assert teams.reload.all? { |team| team.division.nil? }
  end

  test "seed enqueues job" do
    Divisions::SeedJob.expects(:perform_now)
    @division.seed(1)
  end

  test "dirty_seed?" do
    type = 'single_elimination_8'
    division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)
    @teams.update_all(division_id: division.id)

    refute division.seeded?
    assert division.dirty_seed?

    division.seed(1)

    assert division.seeded?
    refute division.dirty_seed?

    division.teams[0].update_attributes(seed: 2)
    division.teams[1].update_attributes(seed: 1)

    assert division.dirty_seed?
  end

  test "updating the bracket_type clears the previous games" do
    division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: 'single_elimination_8')
    assert_equal 12, division.games.count
    division.update_attributes(bracket_type: 'single_elimination_4')
    assert_equal 4, division.games.count
  end
end
