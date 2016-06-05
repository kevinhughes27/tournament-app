require 'test_helper'

class Admin::ScoreReportsControllerTest < ActionController::TestCase
  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    sign_in users(:kevin)
  end

  test "get index" do
    get :index
    assert_response :success
  end
end
