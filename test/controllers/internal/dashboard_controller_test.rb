require 'test_helper'

class Internal::DashboardControllerTest < ActionController::TestCase
  setup do
    sign_in users(:kevin), scope: :internal_user
  end

  test "get show" do
    get :show
    assert_response :ok
  end
end
