require 'test_helper'

class Admin::ScoreReportsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    @tournament = FactoryGirl.create(:tournament)
    FactoryGirl.create(:tournament_user, user: @user, tournament: @tournament)
    set_tournament(@tournament)
    sign_in @user
  end

  test "get index" do
    FactoryGirl.create(:score_report)
    get :index
    assert_response :success
  end
end
