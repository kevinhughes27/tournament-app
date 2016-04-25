require 'test_helper'

class Internal::TournamentsControllerTest < ActionController::TestCase
  setup do
    sign_in :internal_user, users(:kevin)
  end

  test "get index" do
    get :index
    assert_response :ok
  end
end
