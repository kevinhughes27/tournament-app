require 'test_helper'

class AppControllerTest < ActionController::TestCase
  setup do
    @tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:map, tournament: @tournament)
    set_tournament(@tournament)
  end

  test "get show" do
    get :show
    assert_response :success
  end

  test "get show for non existent tournament 404s" do
    set_tournament('wat')
    get :show
    assert_response :not_found
  end
end
