require 'test_helper'

class Internal::LoginControllerTest < ActionController::TestCase

  setup do
    @user = users(:bob)
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "login for internal area" do
    set_subdomain('www')
    user = users(:kevin)
    assert user.staff?

    post :create, params: { user: {email: user.email, password: 'password'} }
    assert_redirected_to internal_path
  end
end
