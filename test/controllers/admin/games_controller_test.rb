require 'test_helper'

class Admin::GamesControllerTest < ActionController::TestCase

  setup do
    @tournament = tournaments(:noborders)
    @game = games(:swift_goose)
    sign_in users(:kevin)
  end

  test "should get index" do
    get :index, tournament_id: @tournament.id
    assert_response :success
    assert_not_nil assigns(:games)
  end

  test "update updates the games score" do
    put :update,
      tournament_id: @tournament.id,
      id: @game.id,
      home_score: 15,
      away_score: 13,
      format: :json

    assert_response :ok

    assert_equal 15, @game.reload.home_score
    assert_equal 13, @game.away_score
  end

    test "update returns game json" do
      put :update,
        tournament_id: @tournament.id,
        id: @game.id,
        home_score: 15,
        away_score: 13,
        format: :json

      assert_response :ok
      assert response_json['game']
    end

end
