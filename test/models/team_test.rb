require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  test "deleting a team unassigns it from all games (home)" do
    team = FactoryBot.create(:team)
    game = FactoryBot.create(:game, home: team)

    team.destroy
    assert_nil game.reload.home
  end

  test "deleting a team unassigns it from all games (away)" do
    team = FactoryBot.create(:team)
    game = FactoryBot.create(:game, away: team)

    team.destroy
    assert_nil game.reload.away
  end

  test "updating a team's division unassigns it from all games (home)" do
    division = FactoryBot.create(:division)
    new_division = FactoryBot.create(:division)
    team = FactoryBot.create(:team, division: division)
    game = FactoryBot.create(:game, division: division, home: team)

    team.update(division: new_division)
    assert_nil game.reload.home
  end

  test "updating a team's division unassigns it from all games (away)" do
    division = FactoryBot.create(:division)
    new_division = FactoryBot.create(:division)
    team = FactoryBot.create(:team, division: division)
    game = FactoryBot.create(:game, division: division, away: team)

    team.update(division: new_division)
    assert_nil game.reload.away
  end

  test "deleting a team nullifies any submitted scores" do
    team = FactoryBot.create(:team)
    report = FactoryBot.create(:score_report, team: team)

    team.destroy
    assert_nil report.reload.team
  end

  test "safe_to_change? is true for a team with no games" do
    team = FactoryBot.create(:team)
    assert team.safe_to_change?
  end

  test "safe_to_change? is false if team is assigned to games" do
    team = FactoryBot.create(:team)
    game = FactoryBot.create(:game, home: team)

    refute team.safe_to_change?
  end

  test "allow_change? is true for a team where the division hasn't started" do
    division = FactoryBot.create(:division)
    team = FactoryBot.create(:team, division: division)
    game = FactoryBot.create(:game, division: division, score_confirmed: false)

    assert team.allow_change?
  end

  test "allow_change? is false for a team with games" do
    division = FactoryBot.create(:division)
    team = FactoryBot.create(:team, division: division)
    game = FactoryBot.create(:game, :finished, division: division)

    refute team.allow_change?
  end

  test "limited number of teams per tournament" do
    tournament = FactoryBot.create(:tournament)
    FactoryBot.create(:team, tournament: tournament)

    stub_constant(Team, :LIMIT, 1) do
      team = FactoryBot.build(:team, tournament: tournament)
      refute team.valid?
      assert_equal ['Maximum of 1 teams exceeded'], team.errors[:base]
    end
  end

  test "seed must be numeric" do
    team = FactoryBot.build(:team, seed: 'a')
    refute team.valid?
    assert_equal ['is not a number'], team.errors[:seed]
  end

  test "division must be division" do
    team = FactoryBot.build(:team, division_id: 999)
    refute team.valid?
    assert_equal ['is invalid'], team.errors[:division]
  end

  test "limit is defined" do
    assert_equal 256, Team::LIMIT
  end
end
