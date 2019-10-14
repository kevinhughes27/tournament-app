require 'test_helper'

class AddUserPasswordTest < ApiTest
  setup do
    login_user
    @output = '{ success message }'
  end

  test "add existing user" do
    user = FactoryBot.create(:user)
    input = { email: user.email }

    execute_graphql("addUser", "AddUserInput", input, @output)

    assert_success
    assert_message "User added"
  end

  test "invite new user" do
    input = { email: "new_user@example.com" }

    execute_graphql("addUser", "AddUserInput", input, @output)

    assert_success
    assert_message "User invited"
  end

  test "add user that already has access" do
    user = FactoryBot.create(:user)
    FactoryBot.create(:tournament_user, user: user, tournament: @tournament)
    input = { email: user.email }

    execute_graphql("addUser", "AddUserInput", input, @output)

    assert_success
    assert_message "User already added"
  end
end
