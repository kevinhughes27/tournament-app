require 'test_helper'

class Internal::LoginControllerTest < ActionController::TestCase

  setup do
    @user = FactoryGirl.create(:user)
    @tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:tournament_user, user: @user, tournament: @tournament)
    set_tournament(@tournament)
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "login for internal area" do
    set_subdomain('www')
    user = FactoryGirl.create(:user, email: 'kevinhughes27@gmail.com')
    assert user.staff?

    post :create, params: { user: {email: user.email, password: 'password'} }
    assert_redirected_to internal_path
  end
end
