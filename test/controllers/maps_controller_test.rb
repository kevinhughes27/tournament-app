require 'test_helper'

class Admin::MapsControllerTest < ActionController::TestCase

  setup do
    http_login('admin', 'nobo')
    @tournament = tournaments(:noborders)
    @map = maps(:ultimate_park)
  end

  test "should get new" do
    get :new, tournament_id: @tournament
    assert_response :success
  end

  test "should show map" do
    get :show, tournament_id: @tournament, id: @map
    assert_response :success
  end

end
