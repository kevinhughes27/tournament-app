require 'test_helper'

class Admin::GamesControllerTest < ActionController::TestCase
  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    @game = games(:swift_goose)
    sign_in users(:kevin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:games)
  end

  test "blank slate" do
    @tournament.games.destroy_all
    get :index
    assert_response :success
    assert_match 'blank-slate', response.body
  end

  test "update updates the games score" do
    put :update, params: {
      id: @game.id,
      home_score: 15,
      away_score: 13
    }, format: :json

    assert_response :ok

    assert_equal 15, @game.reload.home_score
    assert_equal 13, @game.away_score
  end

  # TODO make this test work
  # test "updating scores broadcasts changes" do
  #   put :update, params: {
  #     id: @game.id,
  #     home_score: 15,
  #     away_score: 13
  #   }, format: :json
  #
  #   assert_response :ok
  #   ActionCable.server.expects(:broadcast)
  # end
end
