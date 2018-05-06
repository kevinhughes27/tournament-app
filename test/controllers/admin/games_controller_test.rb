require 'test_helper'

class Admin::GamesControllerTest < AdminControllerTest
  test "should get index" do
    FactoryGirl.create(:game)
    get :index
    assert_response :success
    assert_not_nil assigns(:games)
  end

  test "blank slate" do
    get :index
    assert_response :success
    assert_match 'blank-slate', response.body
  end

  test "update a games score" do
    game = FactoryGirl.create(:game)

    put :update, params: {
      id: game.id,
      home_score: 15,
      away_score: 13
    }, format: :json

    assert_response :ok
    assert_equal 15, game.reload.home_score
    assert_equal 13, game.away_score
  end

  test "update a games score (unsafe)" do
    game1 = FactoryGirl.create(:game, :finished)
    game2 = FactoryGirl.create(:game, :finished, home_prereq: "W#{game1.bracket_uid}")

    put :update, params: {
      id: game1.id,
      home_score: game1.away_score,
      away_score: game1.home_score
    }, format: :json

    assert_response :unprocessable_entity
  end

  test "update a games score (unsafe) + force" do
    game1 = FactoryGirl.create(:game, :finished)
    game2 = FactoryGirl.create(:game, :finished, home_prereq: "W#{game1.bracket_uid}")

    new_home_score = game1.away_score
    new_away_score = game1.home_score

    put :update, params: {
      id: game1.id,
      home_score: new_home_score,
      away_score: new_away_score,
      force: 'true'
    }, format: :json

    assert_response :ok

    assert_equal new_home_score, game1.reload.home_score
    assert_equal new_away_score, game1.away_score
  end

  test "updating scores broadcasts changes" do
    game = FactoryGirl.create(:game)

    ActionCable.server.expects(:broadcast)

    put :update, params: {
      id: game.id,
      home_score: 15,
      away_score: 13
    }, format: :json

    assert_response :ok
  end
end
