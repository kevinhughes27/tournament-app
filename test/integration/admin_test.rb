require 'test_helper'

class AdminTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:kevin)
    @tournament = tournaments(:noborders)
  end

  test "admin 404s" do
    login_as(@user)
    get 'http://no-borders.lvh.me/admin/wat'
    assert_equal 404, status
    assert_template 'admin/404', layout: 'admin'
  end

  test "admin 500s" do
    login_as(@user)
    Admin::TeamsController.any_instance.expects(:load_team).raises(Exception)
    Rollbar.expects(:error)
    get 'http://no-borders.lvh.me/admin/teams/1'
    assert_equal 500, status
    assert_template 'admin/500', layout: 'admin'
  end

  private

  def login_as(user)
    get 'http://no-borders.lvh.me/admin'
    follow_redirect!
    assert_equal 200, status
    assert_equal new_user_session_path, path

    post new_user_session_path, user: {email: user.email, password: 'password'}
    follow_redirect!
    assert_equal 200, status
    assert_equal "/admin", path
  end
end
