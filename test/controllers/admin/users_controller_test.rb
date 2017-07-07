require 'test_helper'

class Admin::UsersControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:tournament_user, user: @user, tournament: @tournament)
    set_tournament(@tournament)
    sign_in @user
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
    user = FactoryGirl.build(:user)
    params = { user: { email: user.email, password: user.password }}

    assert_difference "User.count" do
      assert_difference "TournamentUser.count" do
        post :create, params: params
        assert_redirected_to admin_users_path
      end
    end
  end
end
