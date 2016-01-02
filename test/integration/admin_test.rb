require 'test_helper'

class AdminTest < ActionDispatch::IntegrationTest

  setup do
    @user = users(:kevin)
  end

  test "admin requires login" do
    get '/no-borders/admin'
    follow_redirect!
    assert_equal 200, status
    assert_equal new_user_session_path, path

    post new_user_session_path, user: {email: @user.email, password: 'password'}
    follow_redirect!
    assert_equal 200, status
    assert_equal "/no-borders/admin", path
  end

  test "admin requires login and a tournament user" do
    tournament = tournaments(:jazz_fest)
    refute tournament.users.find_by(id: @user.id)

    get '/jazz-fest/admin'
    follow_redirect!
    assert_equal 200, status
    assert_equal new_user_session_path, path

    post new_user_session_path, user: {email: @user.email, password: 'password'}
    assert_equal 200, status
    assert_equal new_user_session_path, path
  end

  test "admin login remembers original request" do
    get '/no-borders/admin/fields'
    follow_redirect!
    assert_equal 200, status
    assert_equal new_user_session_path, path

    post new_user_session_path, user: {email: @user.email, password: 'password'}
    follow_redirect!
    assert_equal 200, status
    assert_equal "/no-borders/admin/fields", path
  end

end
