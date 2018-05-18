require 'test_helper'

class UpdateTeamTest < ApiTest
  setup do
    login_user
    @output = '{ success, confirm, errors }'
  end

  test "update a team" do
    team = FactoryGirl.create(:team)
    attributes = FactoryGirl.attributes_for(:team).except(:tournament, :division)
    input = {team_id: team.id, **attributes}

    execute_graphql("updateTeam", "UpdateTeamInput", input, @output)

    assert_success
    assert_equal attributes[:name], team.reload.name
  end

  test "update a team with errors" do
    team = FactoryGirl.create(:team)
    input = {team_id: team.id, name: ''}

    execute_graphql("updateTeam", "UpdateTeamInput", input, @output)
    assert_failure "Name can't be blank"
  end

  test "update a team with unsafe input" do
    team = FactoryGirl.create(:team, seed: 2)
    FactoryGirl.create(:game, home: team)
    input = {team_id: team.id, seed: 3}

    execute_graphql("updateTeam", "UpdateTeamInput", input, @output)
    assert_confirmation_required "There are games scheduled for this team. Updating the team may unassign it from those games. You will need to re-seed the #{team.division.name} division."
  end

  test "confirm update a team with unsafe params" do
    team = FactoryGirl.create(:team, seed: 2)
    FactoryGirl.create(:game, home: team)
    input = {team_id: team.id, seed: 3, confirm: true}

    execute_graphql("updateTeam", "UpdateTeamInput", input, @output)

    assert_success
    assert_equal 3, team.reload.seed
  end

  test "not allowed to update team with unsafe params" do
    team = FactoryGirl.create(:team, seed: 2)
    FactoryGirl.create(:game, :finished, home: team)
    input = {team_id: team.id, seed: 3}

    execute_graphql("updateTeam", "UpdateTeamInput", input, @output)
    assert_failure "There are games in this team's division that have been scored. In order to update this team you need to delete the #{team.division.name} division first."
  end
end
