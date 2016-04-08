require 'test_helper'

class InternalLoginTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:kevin)
  end

  test "internal area requires login" do
    get 'http://lvh.me/internal'
    follow_redirect!
    assert_equal 200, status
    assert_equal new_user_session_path, path

    post new_user_session_path, user: {email: @user.email, password: 'password'}
    follow_redirect!
    assert_equal 200, status
    assert_equal "/internal", path
  end
end
