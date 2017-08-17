require 'test_helper'

class AdminErrorHandlingTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryGirl.create(:user)
    @tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:tournament_user, user: @user, tournament: @tournament)
    ReactOnRails::TestHelper.ensure_assets_compiled
  end

  test "admin 404s for invalid route" do
    login_as(@user)
    get "http://#{@tournament.handle}.lvh.me/admin/wat"
    assert_equal 404, status
    assert_template 'admin/404', layout: 'admin'
  end

  test "admin 404s for record not found" do
    login_as(@user)
    get "http://#{@tournament.handle}.lvh.me/admin/teams/99"
    assert_equal 404, status
    assert_template 'admin/404', layout: 'admin'
  end

  private

  def login_as(user)
    get "http://#{@tournament.handle}.lvh.me/admin"
    follow_redirect!
    assert_equal 200, status
    assert_equal new_user_session_path, path

    post new_user_session_path, params: { user: {email: user.email, password: 'password'} }
    follow_redirect!
    assert_equal 200, status
    assert_equal "/admin", path
  end
end
