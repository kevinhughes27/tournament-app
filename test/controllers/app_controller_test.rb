require 'test_helper'

class AppControllerTest < ActionController::TestCase
  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    @report = score_reports(:swift_goose)
    @token = score_report_confirm_tokens(:goose_confirm_token)
  end

  test "get show" do
    get :show
    assert_response :success
  end

  test "get show for non existent tournament 404s" do
    set_tournament('wat')
    get :show
    assert_response :not_found
  end

  test "create score report" do
    params = @report.attributes.merge(
      submitter_fingerprint: 'some_fingerprint'
    )

    assert_difference "ScoreReport.count", +1 do
      post :score_submit, params: params, format: :json
    end
  end

  test "get confirm page" do
    get :confirm, params: { id: @token.id, token: @token.token }
    assert_response :ok
    assert_template :confirm
  end

  test "get confirm page without token param 404s" do
    get :confirm, params: { id: @token.id }
    assert_response :not_found
    assert_template 'token_not_found'
  end

  test "confirm a score report" do
    game = @report.game
    game.update_columns(home_score: nil, away_score: nil, score_confirmed: false)
    refute game.score_confirmed

    params = @report.attributes.merge(
      id: @token.id,
      token: @token.token,
      submitter_fingerprint: 'fingerprint'
    )

    assert_difference "ScoreReport.count", +1 do
      post :confirm, params: params
      assert_response :ok
      assert_template 'confirm_score_success'
    end

    assert game.reload.score_confirmed
  end

  test "confirm a score report requires token" do
    params = @report.attributes.merge(
      id: @token.id,
      submitter_fingerprint: 'fingerprint'
    )

    assert_no_difference "ScoreReport.count" do
      post :confirm, params: params
      assert_response :not_found
      assert_template 'token_not_found'
    end
  end
end
