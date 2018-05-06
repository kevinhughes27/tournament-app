require 'test_helper'

class Admin::ScoreReportsControllerTest < AdminControllerTest
  test "get index" do
    FactoryGirl.create(:score_report)
    get :index
    assert_response :success
  end
end
