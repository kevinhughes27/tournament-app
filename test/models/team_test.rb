require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  setup do
    @team = teams(:swift)
    @game = games(:swift_goose)
    @tournament = tournaments(:noborders)
  end

  test "deleting a team unassigns if from all games (home)" do
    assert_equal @team, @game.home
    @team.destroy
    assert_nil @game.reload.home
  end

  test "deleting a team unassigns if from all games (away)" do
    team = teams(:goose)
    assert_equal team, @game.away
    team.destroy
    assert_nil @game.reload.away
  end

  test "safe_to_delete? is true for a team with no games" do
    team = teams(:shrike)
    assert team.safe_to_delete?
  end

  test "safe_to_delete? is false if team is assigned to games" do
    refute @team.safe_to_delete?
  end

  test "allow_delete is true for a team where the division hasn't started" do
    team = teams(:stella)
    assert team.allow_delete?
  end

  test "allow_delete is false for a team games" do
    refute @team.allow_delete?
  end

  test "limited number of teams per tournament" do
    stub_constant(Team, :LIMIT, 2) do
      team = @tournament.teams.build(name: 'new team')
      refute team.valid?
      assert_equal ['Maximum of 2 teams exceeded'], team.errors[:base]
    end
  end

  test "limit is define" do
    assert_equal 256, Team::LIMIT
  end
end
