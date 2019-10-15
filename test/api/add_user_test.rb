require 'test_helper'

class AddUserPasswordTest < ApiTest
  setup do
    login_user
    @output = '{ success message }'
  end

  test "add existing user" do
    user = FactoryBot.create(:user, email: 'existing_user@example.com')
    input = { email: user.email }

    execute_graphql("addUser", "AddUserInput", input, @output)

    assert_success
    assert_message "User added"

    assert_equal user, TournamentUser.last.user, "tournament_user was not created"

    email = ActionMailer::Base.deliveries.last

    assert_equal "existing_user@example.com", email.to[0]
    assert_equal "You've been added to a tournament", email.subject

    assert_match(/#{@tournament.url}/, email.body.to_s)
    assert_match(/#{@tournament.admin_url}/, email.body.to_s)
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

    assert_match(/#{@tournament.url}/, email.body.to_s)
    assert_match(/#{@tournament.url}\/invitation\/accept/, email.body.to_s)
  end

  test "add user that already has access" do
    user = FactoryBot.create(:user)
    FactoryBot.create(:tournament_user, user: user, tournament: @tournament)
    input = { email: user.email }

    execute_graphql("addUser", "AddUserInput", input, @output)

    assert_success
    assert_message "User already added"
  end

  test "invalid email error" do
    input = { email: "not an email" }

    execute_graphql("addUser", "AddUserInput", input, @output)

    assert_failure('Invalid email')
  end
end
