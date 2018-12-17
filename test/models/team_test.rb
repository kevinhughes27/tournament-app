require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  test "deleting a team nullifies any submitted scores" do
    team = FactoryBot.create(:team)
    report = FactoryBot.create(:score_report, team: team)

    team.destroy
    assert_nil report.reload.team
  end

  test "allow_delete? is true for a team with no games" do
    team = FactoryBot.create(:team)
    assert team.allow_delete?
  end

  test "allow_delete? is false if team is assigned to games" do
    team = FactoryBot.create(:team)
    game = FactoryBot.create(:game, home: team)

    refute team.allow_delete?
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

  test "limit is defined" do
    assert_equal 256, Team::LIMIT
  end
end
