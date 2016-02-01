require 'test_helper'

class Admin::MapControllerTest < ActionController::TestCase

  setup do
    @tournament = tournaments(:noborders)
    @user = users(:kevin)
    sign_in @user
  end

  test "get map page" do
    get :show, tournament_id: @tournament.id
  end

  test "update map" do
    put :update, tournament_id: @tournament.id, tournament: map_params
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
