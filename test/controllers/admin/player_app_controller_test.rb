require 'test_helper'

class Admin::PlayerAppControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:tournament_user, user: @user, tournament: @tournament)
    set_tournament(@tournament)
    sign_in @user
  end

  test "get show page" do
    FactoryGirl.create(:map)
    get :show
    assert_response :ok
  end
end
