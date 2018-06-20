require 'test_helper'

class PasswordsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)

    set_tournament(@tournament)

    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "get new (aka password reset)" do
    get :new
    assert_response :ok
  end

  test "post create (aka password reset)" do
    post :create, params: { user: { email: @user.email } }
    assert_redirected_to new_user_password_path
  end

  test "get edit (aka change password)" do
    get :edit, params: { reset_password_token: 'token' }
    assert_response :ok
  end

  test "put update (aka change password)" do
    token = @user.send_reset_password_instructions
    params = { user: { password: 'password', password_confirmation: 'password', reset_password_token: token } }
    put :update, params: params
    assert_redirected_to new_user_session_path
  end

  test "update error" do
    token = @user.send_reset_password_instructions
    params = { user: {password: '', password_confirmation: '', reset_password_token: token } }
    put :update, params: params
    assert_response :ok
  end
end
