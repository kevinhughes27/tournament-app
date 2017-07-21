require 'test_helper'

class Admin::HomeControllerTest < AdminControllerTestCase
  test "get show" do
    get :show
    assert_response :ok
  end
end
