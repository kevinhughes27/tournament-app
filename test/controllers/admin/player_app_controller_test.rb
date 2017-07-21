require 'test_helper'

class Admin::PlayerAppControllerTest < AdminControllerTestCase
  test "get show page" do
    FactoryGirl.create(:map)
    get :show
    assert_response :ok
  end
end
