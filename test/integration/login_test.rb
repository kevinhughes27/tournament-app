require 'test_helper'

class LoginTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryGirl.create(:user)
    @tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:tournament_user, user: @user, tournament: @tournament)
  end

  test "tournament login" do
    get 'http://lvh.me/log_in'
    assert_equal 200, status
    assert_equal new_user_session_path, path

    post new_user_session_path, params: { user: {email: @user.email, password: 'password'} }
    follow_redirect!
    assert_equal 200, status
    assert_equal "/admin", path
  end

  test "admin requires login" do
    get "http://#{@tournament.handle}.lvh.me/admin"
    follow_redirect!
    assert_equal 200, status
    assert_equal new_user_session_path, path

    post new_user_session_path, params: { user: {email: @user.email, password: 'password'} }
    follow_redirect!
    assert_equal 200, status
    assert_equal "/admin", path
  end

  test "admin requires login and a tournament user" do
    tournament = FactoryGirl.create(:tournament)
    refute tournament.users.find_by(id: @user.id)

    get "http://#{tournament.handle}.lvh.me/admin"
    follow_redirect!
    assert_equal 200, status
    assert_equal new_user_session_path, path

    post new_user_session_path, params: { user: {email: @user.email, password: 'password'} }
    assert_equal 200, status
    assert_equal new_user_session_path, path
  end

  test "admin login remembers original request" do
    get "http://#{@tournament.handle}.lvh.me/admin/fields"
    follow_redirect!
    assert_equal 200, status
    assert_equal new_user_session_path, path

    post new_user_session_path, params: {user: {email: @user.email, password: 'password'} }
    follow_redirect!
    assert_equal 200, status
    assert_equal "/admin/fields", path
  end
end
