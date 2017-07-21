require 'test_helper'

class Admin::MapControllerTest < AdminControllerTestCase
  test "get map page" do
    FactoryGirl.create(:map)
    get :show
  end

  test "update map" do
    FactoryGirl.create(:map)
    put :update, params: { tournament: map_params }
    assert_response :ok
    assert_equal 45, @tournament.map.reload.lat
  end

  private

  def map_params
    {
      map_attributes: {
        lat: 45,
        long: 55,
        zoom: 15
      }
    }
  end
end
