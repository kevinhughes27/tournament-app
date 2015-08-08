require 'test_helper'

class Admin::BracketsControllerTest < ActionController::TestCase

  setup do
    http_login('admin', 'nobo')
    @tournament = tournaments(:noborders)
  end

  test "should get index" do
    get :index, tournament_id: @tournament.id
    assert_response :success
  end

end
