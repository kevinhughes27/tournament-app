require 'test_helper'

class Admin::AccountControllerTest < ActionController::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @user = users(:kevin)
    sign_in @user
  end

  test "get account page" do
    get :show, tournament_id: @tournament.id
    assert_response :success
  end

  test "update account" do
    put :update, tournament_id: @tournament.id, user: {
      email: 'bob@example.com'
    }

    assert_equal 'bob@example.com', @user.reload.email
  end
end
