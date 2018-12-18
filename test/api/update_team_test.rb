require 'test_helper'

class UpdateTeamTest < ApiTest
  setup do
    login_user
    @output = '{ success message userErrors { field message } }'
  end

  test "update a team" do
    team = FactoryBot.create(:team)
    attributes = FactoryBot.attributes_for(:team).except(:tournament)
    input = {id: team.id, **attributes}

    execute_graphql("updateTeam", "UpdateTeamInput", input, @output)

    assert_success
    assert_equal attributes[:name], team.reload.name
  end

  test "update a team with errors" do
    team = FactoryBot.create(:team)
    input = {id: team.id, name: ''}

    execute_graphql("updateTeam", "UpdateTeamInput", input, @output)
    assert_failure({'field' => 'name', 'message' => "can't be blank"})
  end
end
