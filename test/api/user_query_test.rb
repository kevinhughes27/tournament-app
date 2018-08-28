require 'test_helper'

class UserQueryTest < ApiTest
  test "email field is hidden to the public" do
    user = FactoryBot.create(:staff)

    query_graphql(
      "users {
      	name
        email
      }",
      expect_error: "Field 'email' doesn't exist on type 'User'"
    )
  end

  test "email field is present for authenticated requests" do
    login_user
    user = FactoryBot.create(:staff)

    query_graphql("
      users {
      	name
        email
      }
    ")

    assert_equal user.email,  query_result['users'].first['email']
  end
end
