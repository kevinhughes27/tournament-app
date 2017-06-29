require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  test "deleting a team unassigns it from all games (home)" do
    team = FactoryGirl.create(:team)
    game = FactoryGirl.create(:game, home: team)

    team.destroy
    assert_nil game.reload.home
  end

  test "deleting a team unassigns it from all games (away)" do
    team = FactoryGirl.create(:team)
    game = FactoryGirl.create(:game, away: team)

    team.destroy
    assert_nil game.reload.away
  end

  test "updating a team's division unassigns if from all games (home)" do
    division = FactoryGirl.create(:division)
    team = FactoryGirl.create(:team, division: division)
    game = FactoryGirl.create(:game, division: division, home: team)

    team.update(division: FactoryGirl.build(:division))
    assert_nil game.reload.home
  end

  test "updating a team's division unassigns if from all games (away)" do
    division = FactoryGirl.create(:division)
    team = FactoryGirl.create(:team, division: division)
    game = FactoryGirl.create(:game, division: division, away: team)

    team.update(division: FactoryGirl.build(:division))
    assert_nil game.reload.away
  end

  test "deleting a team nullifies any submitted scores" do
    team = FactoryGirl.create(:team)
    report = FactoryGirl.create(:score_report, team: team)

    team.destroy
    assert_nil report.reload.team
  end

  test "safe_to_change? is true for a team with no games" do
    team = FactoryGirl.create(:team)
    assert team.safe_to_change?
  end

  test "safe_to_change? is false if team is assigned to games" do
    team = FactoryGirl.create(:team)
    game = FactoryGirl.create(:game, home: team)

    refute team.safe_to_change?
  end

  test "allow_change? is true for a team where the division hasn't started" do
    division = FactoryGirl.create(:division)
    team = FactoryGirl.create(:team, division: division)
    game = FactoryGirl.create(:game, division: division, score_confirmed: false)

    assert team.allow_change?
  end

  test "allow_change? is false for a team with games" do
    division = FactoryGirl.create(:division)
    team = FactoryGirl.create(:team, division: division)
    game = FactoryGirl.create(:finished_game, division: division, score_confirmed: true)

    refute team.allow_change?
  end

  test "limited number of teams per tournament" do
    tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:team, tournament: tournament)

    stub_constant(Team, :LIMIT, 1) do
      team = FactoryGirl.build(:team, tournament: tournament)
      refute team.valid?
      assert_equal ['Maximum of 1 teams exceeded'], team.errors[:base]
    end
  end

  test "seed must be numeric" do
    team = FactoryGirl.build(:team, seed: 'a')
    refute team.valid?
    assert_equal ['is not a number'], team.errors[:seed]
  end

  test "division must be division" do
    team = FactoryGirl.build(:team, division_id: 999)
    refute team.valid?
    assert_equal ['is invalid'], team.errors[:division]
  end

  test "limit is defined" do
    assert_equal 256, Team::LIMIT
  end
end
