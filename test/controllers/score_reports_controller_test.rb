require 'test_helper'

class ScoreReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tournament = tournaments(:noborders)
    host! "#{@tournament.handle}.lvh.me"

    @report = score_reports(:swift_goose)
    @token = score_report_confirm_tokens(:goose_confirm_token)

    @game = @report.game
    @game.update_columns(home_score: nil, away_score: nil, score_confirmed: false)
  end

  test "create score report [confirm_setting: automatic]" do
    @tournament.update_columns(game_confirm_setting: 'automatic')

    assert_difference "ScoreReport.count", +1 do
      post '/submit_score', params: report_params
    end

    assert @game.reload.score_confirmed
  end

  test "create score report [confirm_setting: validated]" do
    @tournament.update_columns(game_confirm_setting: 'validated')

    assert_difference "ScoreReport.count", +1 do
      post '/submit_score', params: report_params
    end

    refute @game.reload.score_confirmed
  end

  test "create score report [confirm_setting: multiple]" do
    @tournament.update_columns(game_confirm_setting: 'multiple')
    assert_equal 2, @game.score_reports.count

    assert_difference "ScoreReport.count", +1 do
      post '/submit_score', params: report_params
    end

    assert @game.reload.score_confirmed
  end

  test "create score report with one error" do
    params = report_params.merge(team_score: -1)
    post '/submit_score', params: params
    assert_response :unprocessable_entity
    assert_equal ['Team score must be greater than or equal to 0'], response_json
  end

  test "create score report with multiple errors" do
    params = report_params.merge(team_score: -1, opponent_score: -1)
    post '/submit_score', params: params
    assert_response :unprocessable_entity
    assert_equal ['Team score must be greater than or equal to 0',
      'Opponent score must be greater than or equal to 0'], response_json
  end

  test "get confirm page" do
    get "/confirm/#{@token.id}", params: { token: @token.token }
    assert_response :ok
    assert_template :confirm
  end

  test "get confirm page without token param 404s" do
    get "/confirm/#{@token.id}"
    assert_response :not_found
    assert_template 'token_not_found'
  end

  test "confirm a score report" do
    assert_difference "ScoreReport.count", +1 do
      post "/confirm/#{@token.id}", params: confirm_params
      assert_response :ok
      assert_template 'confirm_score_success'
    end

    assert @game.reload.score_confirmed
  end

  test "confirm a score report error" do
    ScoreReportConfirm.any_instance.stubs(:succeeded?).returns(false)
    post "/confirm/#{@token.id}", params: confirm_params
    assert_response :unprocessable_entity
    assert_template 'confirm_score_error'
  end

  test "confirm a score report requires token" do
    assert_no_difference "ScoreReport.count" do
      post "/confirm/#{@token.id}", params: report_params
      assert_response :not_found
      assert_template 'token_not_found'
    end
  end

  test "reporting a different score creates a dispute" do
    @game.update_columns(score_confirmed: true)
    params = confirm_params.merge(team_score: @report.opponent_score + 1)

    assert_difference "ScoreReport.count", +1 do
      assert_difference "ScoreDispute.count", +1 do
        post "/confirm/#{@token.id}", params: params
        assert_response :ok
        assert_template 'submit_score_success'
      end
    end

    assert_equal 'open', ScoreDispute.last.status
  end

  test "reporting a different score doesn't create a dispute if there already is one" do
    @game.update_columns(score_confirmed: true)
    ScoreDispute.create!(
      tournament: @tournament,
      game: @game
    )

    params = confirm_params.merge(team_score: @report.opponent_score + 1)

    assert_difference "ScoreReport.count", +1 do
      assert_no_difference "ScoreDispute.count" do
        post "/confirm/#{@token.id}", params: params
        assert_response :ok
        assert_template 'submit_score_success'
      end
    end

    assert_equal 'open', ScoreDispute.last.status
  end

  private

  def report_params
    @report.attributes.merge(
      submitter_fingerprint: 'some_fingerprint'
    )
  end

  def confirm_params
    {
      token: @token.token,
      game_id: @game.id,
      team_id: @report.other_team.id,
      team_score: @report.opponent_score,
      opponent_score: @report.team_score,
      rules_knowledge: 3,
      fouls: 3,
      fairness: 3,
      attitude: 3,
      communication: 3,
      comments: '',
      submitter_fingerprint: 'fingerprint'
    }
  end
end
