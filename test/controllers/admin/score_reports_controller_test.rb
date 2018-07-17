require 'test_helper'

class Admin::ScoreReportsControllerTest < AdminControllerTest
  test "get index" do
    FactoryBot.create(:score_report)
    get :index
    assert_response :success
  end

  test "export csv" do
    FactoryBot.create(:score_report)
    get :export_csv, format: :csv
    assert_response :success
    assert_equal "text/csv", response.content_type
  end
end
