require 'test_helper'

class AdminErrorHandlingTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)
  end

  test "admin 404s for invalid route" do
    login_as(@user)
    get "http://#{@tournament.handle}.lvh.me/admin/wat"
    assert_equal 404, status
    assert_match "There's nothing here!", response.body
  end

  test "admin 404s for record not found" do
    login_as(@user)
    get "http://#{@tournament.handle}.lvh.me/admin/teams/99"
    assert_equal 404, status
    assert_match "There's nothing here!", response.body
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
