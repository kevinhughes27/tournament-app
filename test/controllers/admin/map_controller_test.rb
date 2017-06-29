require 'test_helper'

class Admin::MapControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:tournament_user, user: @user, tournament: @tournament)
    set_tournament(@tournament)
    sign_in @user
  end

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
