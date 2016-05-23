require 'test_helper'

class Admin::PlayerAppControllerTest < ActionController::TestCase
  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    @user = users(:kevin)
    sign_in @user
  end

  test "get show page" do
    get :show
    assert_response :ok
  end
end
