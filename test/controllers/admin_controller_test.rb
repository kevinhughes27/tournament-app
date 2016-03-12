require 'test_helper'

class AdminControllerTest < ActionController::TestCase
  tests Admin::HomeController

  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    @user = users(:kevin)
  end

  test "admin requires login" do
    sign_in @user
    get :show
    assert_response :success
  end

  test "admin redirects to login if no session" do
    sign_out @user
    get :show
    assert_redirected_to new_user_session_path
  end

  test "non existent tournament 404s" do
    set_tournament('wat')
    get :show
    assert_response :not_found
  end
end
