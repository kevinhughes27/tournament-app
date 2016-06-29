require 'test_helper'

class Internal::TournamentsControllerTest < ActionController::TestCase
  setup do
    sign_in users(:kevin), scope: :internal_user
  end

  test "get index" do
    get :index
    assert_response :ok
  end
end
