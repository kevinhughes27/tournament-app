require 'test_helper'

class Admin::TournamentsControllerTest < ActionController::TestCase

  setup do
    http_login('admin', 'nobo')
    @tournament = tournaments(:noborders)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:tournaments)
  end

end
