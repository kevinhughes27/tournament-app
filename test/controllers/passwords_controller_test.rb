require 'test_helper'

class PasswordsControllerTest < ActionController::TestCase

  setup do
    @user = users(:kevin)
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    @request.env["devise.mapping"] = Devise.mappings[:user]
  end

  test "get new (aka password reset)" do
    get :new
    assert_response :ok
  end

  test "post create (aka password reset)" do
    post :create, user: {email: @user.email}
    assert_redirected_to new_user_password_path
  end

  test "get edit (aka change password)" do
    get :edit, reset_password_token: 'token'
    assert_response :ok
  end

  test "put update (aka change password)" do
    token = @user.send_reset_password_instructions
    put :update, user: {password: 'password', password_confirmation: 'password', reset_password_token: token}
    assert_redirected_to new_user_session_path
  end

  test "update error" do
    token = @user.send_reset_password_instructions
    put :update, user: {password: '', password_confirmation: '', reset_password_token: token}
    assert_response :ok
    assert_template 'passwords/show'
  end
end
