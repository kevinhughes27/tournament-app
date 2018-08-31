require 'test_helper'

class TeamQueryTest < ApiTest
  test "email field is hidden to the public" do
    team = FactoryBot.create(:team)

    query_graphql("
      teams {
      	name
        email
      }",
      expect_error: "Field 'email' doesn't exist on type 'Team'"
    )
  end

  test "email field is present for authenticated requests" do
    login_user
    team = FactoryBot.create(:team)

    query_graphql("
      teams {
      	name
        email
      }"
    )

    assert_equal team.email, query_result['teams'].first['email']
  end
end
