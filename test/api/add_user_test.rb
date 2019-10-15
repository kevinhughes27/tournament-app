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

    assert_equal @user, User.last.invited_by

    email = ActionMailer::Base.deliveries.last

    assert_equal "new_user@example.com", email.to[0]
    assert_equal "You got an invitation!", email.subject

    assert_match(/#{@tournament.domain}/, email.body.to_s)
    assert_match(/#{@tournament.domain}\/invitation\/accept/, email.body.to_s)
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
