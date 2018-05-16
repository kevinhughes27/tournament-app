require 'test_helper'

class DeleteTeamTest < ApiTest
  setup do
    login_user
    @output = '{ success, confirm, errors }'
  end

  test "delete a team" do
    team = FactoryGirl.create(:team)
    input = {team_id: team.id}

    assert_difference "Team.count", -1 do
      execute_graphql("deleteTeam", "DeleteTeamInput", input, @output)
      assert_success
    end
  end

  test "delete a team needs confirm if seeded but not scored" do
    division = FactoryGirl.create(:division)
    team = FactoryGirl.create(:team, division: division)
    FactoryGirl.create(:game, division: division, home: team)

    input = {team_id: team.id}

    assert_no_difference "Team.count" do
      execute_graphql("deleteTeam", "DeleteTeamInput", input, @output)
      assert_confirmation_required "There are games scheduled for this team. Deleting the team will unassign it from those games. You will need to re-seed the #{team.division.name} division."
    end
  end

  test "confirm delete a team" do
    division = FactoryGirl.create(:division)
    team = FactoryGirl.create(:team, division: division)
    FactoryGirl.create(:game, division: division, home: team)

    input = {team_id: team.id, confirm: true}

    assert_difference "Team.count", -1 do
      execute_graphql("deleteTeam", "DeleteTeamInput", input, @output)
      assert_success
    end
  end

  test "deleting a team removes it from any games" do
    team = FactoryGirl.create(:team)
    game = FactoryGirl.create(:game, :scheduled, home: team)
    input = {team_id: team.id, confirm: true}

    assert_difference "Team.count", -1 do
      execute_graphql("deleteTeam", "DeleteTeamInput", input, @output)
      assert_success
    end

    assert_nil game.reload.home
  end

  test "delete a team not allowed if division has any scores" do
    division = FactoryGirl.create(:division)
    team = FactoryGirl.create(:team, division: division)
    FactoryGirl.create(:game, :finished, division: division, home: team)

    input = {team_id: team.id}

    assert_no_difference "Team.count" do
      execute_graphql("deleteTeam", "DeleteTeamInput", input, @output)
      assert_failure "There are games in this team's division that have been scored. In order to delete this team you need to delete the #{team.division.name} division first."
    end
  end
end
