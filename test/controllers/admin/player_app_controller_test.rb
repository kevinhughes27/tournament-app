require 'test_helper'

class Admin::PlayerAppControllerTest < AdminControllerTest
  test "get show page" do
    FactoryBot.create(:map)
    get :show
    assert_response :ok
  end
end
