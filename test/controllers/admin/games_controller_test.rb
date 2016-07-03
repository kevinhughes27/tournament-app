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

  test "update the games score" do
    put :update, params: {
      id: @game.id,
      home_score: 15,
      away_score: 13
    }, format: :json

    assert_response :ok

    assert_equal 15, @game.reload.home_score
    assert_equal 13, @game.away_score
  end

  test "update creates ScoreEntry" do
    assert_difference "ScoreEntry.count", +1 do
      put :update, params: {
        id: @game.id,
        home_score: 15,
        away_score: 13
      }, format: :json

      assert_response :ok

      assert_equal 15, @game.reload.home_score
      assert_equal 13, @game.away_score
    end
  end

  test "update with resolve param resolves disputes" do
    dispute = ScoreDispute.create!(
      tournament: @tournament,
      game: @game
    )

    put :update, params: {
      id: @game.id,
      home_score: 15,
      away_score: 13,
      resolve: 'true'
    }, format: :json

    assert_response :ok

    assert_equal 15, @game.reload.home_score
    assert_equal 13, @game.away_score
    assert_equal 'resolved', dispute.reload.status
  end

  test "update the games score (unsafe)" do
    Game.create!(
      tournament: @tournament,
      division: @game.division,
      round: 2,
      bracket_uid: 's2',
      home_prereq_uid: "W#{@game.bracket_uid}",
      away_prereq_uid: "Wnon",
      home_score: 1,
      away_score: 2
    )

    put :update, params: {
      id: @game.id,
      home_score: @game.away_score,
      away_score: @game.home_score
    }, format: :json

    assert_response :unprocessable_entity
  end

  test "update the games score (unsafe) + force" do
    Game.create!(
      tournament: @tournament,
      division: @game.division,
      round: 2,
      bracket_uid: 's2',
      home_prereq_uid: "W#{@game.bracket_uid}",
      away_prereq_uid: "Wnon",
      home_score: 1,
      away_score: 2
    )

    put :update, params: {
      id: @game.id,
      home_score: @game.away_score,
      away_score: @game.home_score,
      force: 'true'
    }, format: :json

    assert_response :ok

    assert_equal 1, @game.reload.home_score
    assert_equal 2, @game.away_score
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
