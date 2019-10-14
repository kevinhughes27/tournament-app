require 'test_helper'

class ChangeUserPasswordTest < ApiTest
  setup do
    login_user
    @output = '{ success userErrors { field message } }'
  end

  test "change password" do
    input = { password: 'fooobar2', password_confirmation: 'fooobar2' }

    execute_graphql("changeUserPassword", "ChangeUserPasswordInput", input, @output)

    assert_success
  end
end
