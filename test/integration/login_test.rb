require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:kevin)
    @tournament = tournaments(:noborders)
  end

  test "tournament login" do
    get 'http://lvh.me/sign_in'
    assert_equal 200, status
    assert_equal new_user_session_path, path

    post new_user_session_path, user: {email: @user.email, password: 'password'}
    follow_redirect!
    assert_equal 200, status
    assert_equal "/admin", path
  end

  test "admin requires login" do
    get 'http://no-borders.lvh.me/admin'
    follow_redirect!
    assert_equal 200, status
    assert_equal new_user_session_path, path

    post new_user_session_path, user: {email: @user.email, password: 'password'}
    follow_redirect!
    assert_equal 200, status
    assert_equal "/admin", path
  end

  test "admin requires login and a tournament user" do
    tournament = tournaments(:jazz_fest)
    refute tournament.users.find_by(id: @user.id)

    get 'http://jazz-fest.lvh.me/admin'
    follow_redirect!
    assert_equal 200, status
    assert_equal new_user_session_path, path

    post new_user_session_path, user: {email: @user.email, password: 'password'}
    assert_equal 200, status
    assert_equal new_user_session_path, path
  end

  test "admin login remembers original request" do
    get 'http://no-borders.lvh.me/admin/fields'
    follow_redirect!
    assert_equal 200, status
    assert_equal new_user_session_path, path

    post new_user_session_path, user: {email: @user.email, password: 'password'}
    follow_redirect!
    assert_equal 200, status
    assert_equal "/admin/fields", path
  end
end
