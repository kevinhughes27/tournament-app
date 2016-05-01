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

    Timecop.freeze('2015/08/20') do
      get :index
      assert_response :success
      assert_match '08/21/2015', response.body
      assert_match '9:00', response.body
    end
  end

  test "update schedule" do
    params = {
      games: {
        "0" => {id: @game.id, field_id: @field.id, start_time: @start_time}
      }
    }

    put :update, params: params
    assert_response :ok
    assert_template :index
  end

  test "update schedule 422" do
    params = {
      games: {
        "0" => {id: @game.id, field_id: 'wat', start_time: @start_time}
      }
    }

    put :update, params: params

    assert_response :unprocessable_entity
    assert_equal "Validation failed: Field can't be blank", response_json['error']
  end

  test "can swap 2 games without triggering conflict errors" do
    game1 = games(:swift_goose)
    game2 = games(:pheonix_mavericks)

    game1_original_field = game1.field
    game2_original_field = game2.field

    params = {
      games: {
        "0" => {id: game1.id, field_id: game2.field_id, start_time: game1.start_time},
        "1" => {id: game2.id, field_id: game1.field_id, start_time: game2.start_time}
      }
    }

    put :update, params: params
    assert_response :ok

    assert_equal game1_original_field, game2.reload.field
    assert_equal game2_original_field, game1.reload.field
  end
end
