require 'test_helper'

class UpdateTeamTest < ApiTest
  setup do
    login_user
    @output = '{ success confirm message userErrors { field message } }'
  end

  test "update a team" do
    team = FactoryBot.create(:team)
    attributes = FactoryBot.attributes_for(:team).except(:tournament, :division)
    input = {id: relay_id('Team', team.id), **attributes}

    execute_graphql("updateTeam", "UpdateTeamInput", input, @output)

    assert_success
    assert_equal attributes[:name], team.reload.name
  end

  test "un-set seed" do
    team = FactoryBot.create(:team, seed: 1)
    attributes = FactoryBot.attributes_for(:team).except(:tournament, :division)
    input = {id: relay_id('Team', team.id), seed: ''}

    execute_graphql("updateTeam", "UpdateTeamInput", input, @output)

    assert_success
    assert_nil team.reload.seed
  end

  test "update a team with errors" do
    team = FactoryBot.create(:team)
    input = {id: relay_id('Team', team.id), name: ''}

    execute_graphql("updateTeam", "UpdateTeamInput", input, @output)
    assert_failure({'field' => 'name', 'message' => "can't be blank"})
  end

  test "update a team with unsafe input" do
    team = FactoryBot.create(:team, seed: 2)
    FactoryBot.create(:game, home: team)
    input = {id: relay_id('Team', team.id), seed: 3}

    execute_graphql("updateTeam", "UpdateTeamInput", input, @output)
    assert_confirmation_required "There are games scheduled for this team. Updating the team may unassign it from those games. You will need to re-seed the #{team.division.name} division."
  end

  test "confirm update a team with unsafe params" do
    team = FactoryBot.create(:team, seed: 2)
    FactoryBot.create(:game, home: team)
    input = {id: relay_id('Team', team.id), seed: 3, confirm: true}

    execute_graphql("updateTeam", "UpdateTeamInput", input, @output)

    assert_success
    assert_equal 3, team.reload.seed
  end

  test "not allowed to update team with unsafe params" do
    team = FactoryBot.create(:team, seed: 2)
    FactoryBot.create(:game, :finished, home: team)
    input = {id: relay_id('Team', team.id), seed: 3}

    execute_graphql("updateTeam", "UpdateTeamInput", input, @output)
    assert_failure "There are games in this team's division that have been scored. In order to update this team you need to delete the #{team.division.name} division first."
  end
end
