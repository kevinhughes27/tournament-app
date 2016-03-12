require 'test_helper'

class Admin::ScheduleControllerTest < ActionController::TestCase

  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    sign_in users(:kevin)
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "blank slate" do
    @tournament.games.destroy_all
    get :index
    assert_response :success
    assert_match 'blank-slate', response.body
  end

  test "first row is set to time.now" do
    @tournament.games.update_all(field_id: nil, start_time: nil)

    Timecop.freeze do
      get :index
      assert_response :success
      assert_match Time.now.to_formatted_s(:datetimepicker), response.body
    end
  end

end
