require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  tests Admin::HomeController

  setup do
    @tournament = tournaments(:noborders)
    @user = users(:kevin)
  end

  test "admin requires login" do
    sign_in @user
    get :show, tournament_id: @tournament.id
    assert_response :success
  end

  test "admin redirects to login if no session" do
    sign_out @user
    get :show, tournament_id: @tournament.id
    assert_redirected_to new_user_session_path
  end
end
