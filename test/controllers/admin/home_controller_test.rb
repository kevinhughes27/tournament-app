require 'test_helper'

class Admin::HomeControllerTest < AdminControllerTest
  test "get show" do
    get :show
    assert_response :ok
  end
end
