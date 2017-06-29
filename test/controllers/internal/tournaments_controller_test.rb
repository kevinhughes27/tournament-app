require 'test_helper'

class Internal::TournamentsControllerTest < ActionController::TestCase
  setup do
    user = FactoryGirl.create(:user, email: 'kevinhughes27@gmail.com')
    sign_in user, scope: :internal_user
  end

  test "get index" do
    get :index
    assert_response :ok
  end
end
