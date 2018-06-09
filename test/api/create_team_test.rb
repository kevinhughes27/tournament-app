require 'test_helper'

class CreateTeamTest < ApiTest
  setup do
    login_user
    @output = '{ success, userErrors }'
  end

  test "create a team" do
    assert_difference "Team.count" do
      input = FactoryBot.attributes_for(:team).except(:tournament, :division)

      execute_graphql("createTeam", "CreateTeamInput", input, @output)

      assert_success
    end
  end

  test "create a team with errors" do
    input = FactoryBot.attributes_for(:team, name: nil).except(:tournament, :division)

    assert_no_difference "Team.count" do
      execute_graphql("createTeam", "CreateTeamInput", input, @output)
      assert_failure "Name can't be blank"
    end
  end
end
