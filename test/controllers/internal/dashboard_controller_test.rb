require 'test_helper'

class Internal::DashboardControllerTest < ActionController::TestCase
  setup do
    user = FactoryGirl.create(:staff)
    sign_in user, scope: :internal_user
  end

  test "get show" do
    get :show
    assert_response :ok
  end
end
