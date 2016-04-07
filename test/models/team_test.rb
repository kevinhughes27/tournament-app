require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  setup do
    @team = teams(:swift)
    @game = games(:swift_goose)
    @tournament = tournaments(:noborders)
    @division = divisions(:open)
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

  test "deleting a team destroys any submitted scores" do
    report = score_reports(:swift_goose)
    @team.destroy
    assert report.reload.deleted?
  end

  test "updating a team's division unassigns if from all games (home)" do
    assert_equal @team, @game.home
    @team.update_attributes(division: divisions(:women))
    assert_nil @game.reload.home
  end

  test "updating a team's division unassigns if from all games (away)" do
    team = teams(:goose)
    assert_equal team, @game.away
    team.update_attributes(division: divisions(:women))
    assert_nil @game.reload.away
  end

  test "safe_to_change? is true for a team with no games" do
    team = teams(:shrike)
    assert team.safe_to_change?
  end

  test "safe_to_change? is false if team is assigned to games" do
    refute @team.safe_to_change?
  end

  test "allow_change is true for a team where the division hasn't started" do
    team = teams(:stella)
    assert team.allow_change?
  end

  test "allow_change is false for a team with games" do
    refute @team.allow_change?
  end

  test "limited number of teams per tournament" do
    stub_constant(Team, :LIMIT, 2) do
      team = @tournament.teams.build(name: 'new team')
      refute team.valid?
      assert_equal ['Maximum of 2 teams exceeded'], team.errors[:base]
    end
  end

  test "seed must be numeric" do
    attrs = new_team_attributes
    attrs[:seed] = 'a'

    team = Team.new(attrs)

    refute team.valid?
    assert_equal ['is not a number'], team.errors[:seed]
  end

  test "division must be division" do
    attrs = new_team_attributes
    attrs[:division_id] = 999

    team = Team.new(attrs)

    refute team.valid?
    assert_equal ['is invalid'], team.errors[:division]
  end

  test "limit is define" do
    assert_equal 256, Team::LIMIT
  end

  private

  def new_team_attributes
    {
      name: 'Goat',
      division_id: @division.id,
      tournament_id: @tournament.id,
      email: 'goat@goat.com',
      phone: '999-999-9999',
      seed: 1
    }
  end
end
