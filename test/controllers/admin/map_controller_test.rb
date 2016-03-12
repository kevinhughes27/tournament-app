require 'test_helper'

class Admin::MapControllerTest < ActionController::TestCase
  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    @user = users(:kevin)
    sign_in @user
  end

  test "get map page" do
    get :show
  end

  test "update map" do
    put :update, tournament: map_params
    assert_equal 'Map saved.', flash[:notice]
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
