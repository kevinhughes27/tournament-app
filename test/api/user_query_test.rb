require 'test_helper'

class UserQueryTest < ApiTest
  test "viewer is null" do
    user = FactoryBot.create(:user)

    query_graphql(
      "users {
      	name
        email
      }",
      expect_error: "Field 'users' doesn't exist on type 'Query'"
    )
  end

  test "email field is present for authenticated requests" do
    user = FactoryBot.create(:user)
    login_user
    query_graphql("
      users {
      	name
        email
      }
    ")
    assert_equal user.email,  query_result['users'].first['email']
  end
end
