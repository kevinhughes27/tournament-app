require 'test_helper'

class Admin::UsersControllerTest < AdminControllerTest
  test "get new" do
    get :new
    assert_response :success
  end

  test "get index" do
    get :index
    assert_response :success
  end

  test "create a new user" do
    user = FactoryBot.build(:user)
    params = { user: { email: user.email, password: user.password }}

    assert_difference "User.count" do
      assert_difference "TournamentUser.count" do
        post :create, params: params
        assert_redirected_to admin_users_path
      end
    end
  end

  test "add an account for an exisiting user" do
    user = FactoryBot.create(:user)
    params = { user: { email: user.email, password: '' }}

    assert_no_difference "User.count" do
      assert_difference "TournamentUser.count" do
        post :create, params: params
        assert_redirected_to admin_users_path
      end
    end
  end
end
