require 'test_helper'

class Internal::LoginControllerTest < ActionController::TestCase

  setup do
    @user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)
    set_tournament(@tournament)
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "login for internal area" do
    set_subdomain('www')
    user = FactoryBot.create(:staff)
    assert user.staff?

    post :create, params: { user: {email: user.email, password: 'password'} }
    assert_redirected_to internal_path
  end
end
