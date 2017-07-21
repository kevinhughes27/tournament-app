require 'test_helper'

class Admin::ScheduleControllerTest < AdminControllerTestCase
  test "should get index" do
    FactoryGirl.create(:game, :scheduled)
    get :index
    assert_response :success
  end

  test "should get index pdf" do
    FactoryGirl.create(:game, :scheduled)
    get :index, format: 'pdf'
    assert_response :success
  end

  test "blank slate" do
    get :index
    assert_response :success
    assert_match 'blank-slate', response.body
  end

  test "update schedule" do
    game = FactoryGirl.create(:game, :scheduled)
    field = FactoryGirl.create(:field)

    params = {game_id: game.id, field_id: field.id, start_time: Time.now}

    put :update, params: params
    assert_response :ok

    assert game.reload.field_id
    assert game.start_time
  end

  test "update schedule 422" do
    game = FactoryGirl.create(:game, :scheduled)
    params = {game_id: game.id, field_id: 'wat', start_time: Time.now}

    put :update, params: params

    assert_response :unprocessable_entity
    assert_equal "Field can't be blank", response_json['error']
  end

  test "unschedule a game" do
    game = FactoryGirl.create(:game, :scheduled)
    delete :destroy, params: {game_id: game.id}

    assert_response :ok

    refute game.reload.field_id
    refute game.start_time
  end
end
