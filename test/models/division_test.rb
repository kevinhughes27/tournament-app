require 'test_helper'

class DivisionTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @division = divisions(:open)
    @teams = @division.teams
  end

  test "division creates all required games" do
    type = 'single_elimination_8'
    assert_difference "Game.count", +12 do
      create_division(tournament: @tournament, name: 'New Division', bracket_type: type)
    end
  end

  test "division deletes games when it is deleted" do
    type = 'single_elimination_8'
    division = create_division(tournament: @tournament, name: 'New Division', bracket_type: type)

    assert_difference "Game.count", -12 do
      division.destroy
    end
  end

  test "division creates all required places" do
    type = 'single_elimination_8'
    assert_difference "Place.count", +8 do
      create_division(tournament: @tournament, name: 'New Division', bracket_type: type)
    end
  end

  test "division deletes places when it is deleted" do
    type = 'single_elimination_8'
    division = create_division(tournament: @tournament, name: 'New Division', bracket_type: type)

    assert_difference "Place.count", -8 do
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
    division = create_division(tournament: @tournament, name: 'New Division', bracket_type: type)
    @teams.update_all(division_id: division.id)

    refute division.seeded?
    assert division.dirty_seed?

    division.seed

    assert division.seeded?
    refute division.dirty_seed?

    division.teams[0].update(seed: 2)
    division.teams[1].update(seed: 1)

    assert division.dirty_seed?
  end

  test "updating the bracket_type clears the previous games" do
    division = create_division(tournament: @tournament, name: 'New Division', bracket_type: 'single_elimination_8')
    assert_equal 12, division.games.count

    division.update(bracket_type: 'single_elimination_4')

    assert_equal 4, division.games.count
  end

  test "updating the bracket_type resets seeded status" do
    division = create_division(tournament: @tournament, name: 'New Division', bracket_type: 'single_elimination_8')
    @teams.update_all(division_id: division.id)

    division.seed

    assert division.seeded?

    division.update(bracket_type: 'single_elimination_4')

    refute division.seeded?
  end

  test "updating the bracket_type clears the previous places" do
    division = create_division(tournament: @tournament, name: 'New Division', bracket_type: 'single_elimination_8')
    assert_equal 12, division.games.count

    division.update(bracket_type: 'single_elimination_4')

    assert_equal 4, division.games.count
  end

  test "safe_to_delete? is true for division with no games started" do
    division = divisions(:women)
    assert division.safe_to_delete?
  end

  test "safe_to_delete? is false for division with games started" do
    division = divisions(:open)
    refute division.safe_to_delete?
  end

  test "limited number of divisions per tournament" do
    stub_constant(Division, :LIMIT, 2) do
      division = @tournament.divisions.build(name: 'new division')
      refute division.valid?
      assert_equal ['Maximum of 2 divisions exceeded'], division.errors[:base]
    end
  end

  test "limit is define" do
    assert_equal 12, Division::LIMIT
  end

  private

  def create_division(params)
    Division.create!(params)
  end
end
