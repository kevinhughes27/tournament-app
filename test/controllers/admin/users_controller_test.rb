require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    sign_in users(:kevin)
  end

  test "get new" do
    get :new
    assert_response :success
    assert_not_nil assigns(:user)
  end

  test "get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:users)
  end

  test "create a user" do
    assert_difference "User.count" do
      assert_difference "TournamentUser.count" do
        post :create, params: { user: { email: 'bob@bob.com', password: 'password' }}
        assert_redirected_to admin_users_path
      end
    end
  end
end
