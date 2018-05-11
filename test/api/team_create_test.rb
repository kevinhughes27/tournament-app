require 'test_helper'

class TeamCreateTest < ApiTest
  setup do
    login_user
    @output = '{ success, errors }'
  end

  test "create a team" do
    assert_difference "Team.count" do
      input = FactoryGirl.attributes_for(:team).except(:tournament, :division)

      execute_graphql("teamCreate", "TeamCreateInput", input, @output)

      assert_success
    end
  end

  test "create a team with errors" do
    input = FactoryGirl.attributes_for(:team, name: nil).except(:tournament, :division)

    assert_no_difference "Team.count" do
      execute_graphql("teamCreate", "TeamCreateInput", input, @output)
      assert_failure "Name can't be blank"
    end
  end
end
