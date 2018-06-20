require 'test_helper'

class Internal::TournamentsControllerTest < ActionController::TestCase
  setup do
    user = FactoryBot.create(:staff)
    sign_in user, scope: :internal_user
  end

  test "get index" do
    get :index
    assert_response :ok
  end
end
