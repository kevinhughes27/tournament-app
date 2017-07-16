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

  test "update schedule" do
    params = {game_id: @game.id, field_id: @field.id, start_time: @start_time}

    put :update, params: params
    assert_response :ok

    assert @game.reload.field_id
    assert @game.start_time
  end

  test "update schedule 422" do
    params = {game_id: @game.id, field_id: 'wat', start_time: @start_time}

    put :update, params: params

    assert_response :unprocessable_entity
    assert_equal "Field can't be blank", response_json['error']
  end

  test "unschedule a game" do
    delete :destroy, params: {game_id: @game.id}
    assert_response :ok

    refute @game.reload.field_id
    refute @game.start_time
  end
end
