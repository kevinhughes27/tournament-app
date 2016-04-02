require 'test_helper'

class Admin::ScheduleControllerTest < ActionController::TestCase

  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    sign_in users(:kevin)

    @game = games(:swift_goose)
    @field = fields(:upi2)
    @start_time = '2016-03-10 19:13:00 -0500'
  end

  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get index pdf" do
    get :index, format: 'pdf'
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

  test "update schedule" do
    params = {
      games: {
        "0" => {id: @game.id, field_id: @field.id, start_time: @start_time}
      }
    }

    put :update, params
    assert_response :ok
    assert_template :index
  end

  test "update schedule 422" do
    params = {
      games: {
        "0" => {id: @game.id, field_id: 'wat', start_time: @start_time}
      }
    }

    put :update, params

    assert_response :unprocessable_entity
    assert_equal "Validation failed: Field can't be blank", response_json['error']
  end
end
