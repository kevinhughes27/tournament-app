require 'test_helper'

class Admin::HomeControllerTest < ActionController::TestCase
  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    sign_in users(:kevin)
  end

  test "get show" do
    get :show
    assert_response :ok
  end
end
