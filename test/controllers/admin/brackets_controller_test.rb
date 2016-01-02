require 'test_helper'

class Admin::BracketsControllerTest < ActionController::TestCase

  setup do
    @tournament = tournaments(:noborders)
    sign_in users(:kevin)
  end

  test "should get index" do
    get :index, tournament_id: @tournament.id
    assert_response :success
  end

end
