require 'test_helper'

class ScoreReportsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tournament = FactoryGirl.create(:tournament)
    host! "#{@tournament.handle}.lvh.me"

    @game = FactoryGirl.create(:game)
  end

  test "create score report [confirm_setting: automatic]" do
    @tournament.update_columns(game_confirm_setting: 'automatic')
    params = FactoryGirl.attributes_for(:score_report,
      tournament_id: @tournament.id,
      game_id: @game.id,
      team_id: @game.home_id
    )

    assert_difference "ScoreReport.count", +1 do
      post '/submit_score', params: params
    end

    assert @game.reload.score_confirmed
  end

  test "create score report [confirm_setting: validated]" do
    @tournament.update_columns(game_confirm_setting: 'validated')
    params = FactoryGirl.attributes_for(:score_report,
      tournament_id: @tournament.id,
      game_id: @game.id,
      team_id: @game.home_id
    )

    assert_difference "ScoreReport.count", +1 do
      post '/submit_score', params: params
    end

    refute @game.reload.score_confirmed
  end

  test "create agreeing score reports [confirm_setting: multiple]" do
    @tournament.update_columns(game_confirm_setting: 'multiple')

    params = FactoryGirl.attributes_for(:score_report,
      tournament_id: @tournament.id,
      game_id: @game.id,
      team_id: @game.away_id,
      team_score: 0,
      opponent_score: 1
    )

    assert_difference "ScoreReport.count", +1 do
      post '/submit_score', params: params
    end

    refute @game.reload.score_confirmed

    params = FactoryGirl.attributes_for(:score_report,
      tournament_id: @tournament.id,
      game_id: @game.id,
      team_id: @game.home_id,
      team_score: 1,
      opponent_score: 0
    )

    assert_difference "ScoreReport.count", +1 do
      post '/submit_score', params: params
    end

    assert @game.reload.score_confirmed
  end

  test "create score report with one error" do
    params = FactoryGirl.attributes_for(:score_report,
      tournament_id: @tournament.id,
      game_id: @game.id,
      team_id: @game.home_id,
      team_score: -1
    )

    post '/submit_score', params: params
    assert_response :unprocessable_entity
    assert_equal ['Team score must be greater than or equal to 0'], response_json
  end

  test "create score report with multiple errors" do
    params = FactoryGirl.attributes_for(:score_report,
      tournament_id: @tournament.id,
      game_id: @game.id,
      team_id: @game.home_id,
      team_score: -1,
      opponent_score: -1
    )

    post '/submit_score', params: params
    assert_response :unprocessable_entity
    assert_equal ['Team score must be greater than or equal to 0',
      'Opponent score must be greater than or equal to 0'], response_json
  end

  test "get confirm page" do
    token = FactoryGirl.create(:score_report_confirm_token)
    get "/confirm/#{token.id}", params: { token: token.token }
    assert_response :ok
    assert_template :confirm
  end

  test "get confirm page without token param 404s" do
    token = FactoryGirl.create(:score_report_confirm_token)
    get "/confirm/#{token.id}"
    assert_response :not_found
    assert_template 'token_not_found'
  end

  test "confirm a score report" do
    initial_report = FactoryGirl.create(:score_report, game: @game, team: @game.home)
    token = FactoryGirl.create(:score_report_confirm_token, score_report: initial_report)
    params = confirm_params(initial_report, token)

    assert_difference "ScoreReport.count", +1 do
      post "/confirm/#{token.id}", params: params
      assert_response :ok
      assert_template 'confirm_score_success'
    end

    assert @game.reload.score_confirmed
  end

  test "confirm a score report error" do
    initial_report = FactoryGirl.create(:score_report, game: @game, team: @game.home)
    token = FactoryGirl.create(:score_report_confirm_token, score_report: initial_report)
    params = confirm_params(initial_report, token)

    ScoreReportConfirm.any_instance.stubs(:succeeded?).returns(false)

    post "/confirm/#{token.id}", params: params

    assert_response :unprocessable_entity
    assert_template 'confirm_score_error'
  end

  test "confirm a score report requires token" do
    initial_report = FactoryGirl.create(:score_report, game: @game, team: @game.home)
    token = FactoryGirl.create(:score_report_confirm_token, score_report: initial_report)
    params = confirm_params(initial_report, token)
    params.delete(:token)

    assert_no_difference "ScoreReport.count" do
      post "/confirm/#{token.id}", params: params
      assert_response :not_found
      assert_template 'token_not_found'
    end
  end

  test "reporting a different score creates a dispute" do
    @game.update_columns(score_confirmed: true)

    initial_report = FactoryGirl.create(:score_report,
      tournament_id: @tournament.id,
      game_id: @game.id,
      team_id: @game.home_id,
      team_score: 0,
      opponent_score: 1
    )

    token = FactoryGirl.create(:score_report_confirm_token, score_report: initial_report)

    params = FactoryGirl.attributes_for(:score_report,
      tournament_id: @tournament.id,
      game_id: @game.id,
      team_id: @game.home_id,
      team_score: 0,
      opponent_score: 2,
      token: token.token
    )

    assert_difference "ScoreReport.count", +1 do
      assert_difference "ScoreDispute.count", +1 do
        post "/confirm/#{token.id}", params: params
        assert_response :ok
        assert_template 'submit_score_success'
      end
    end

    assert_equal 'open', ScoreDispute.last.status
  end

  test "reporting a different score doesn't create a dispute if there already is one" do
    @game.update_columns(score_confirmed: true)
    ScoreDispute.create!(tournament: @tournament, game: @game)

    initial_report = FactoryGirl.create(:score_report,
      tournament_id: @tournament.id,
      game_id: @game.id,
      team_id: @game.home_id,
      team_score: 0,
      opponent_score: 1
    )

    token = FactoryGirl.create(:score_report_confirm_token, score_report: initial_report)

    params = FactoryGirl.attributes_for(:score_report,
      tournament_id: @tournament.id,
      game_id: @game.id,
      team_id: @game.home_id,
      team_score: 0,
      opponent_score: 2,
      token: token.token
    )

    assert_difference "ScoreReport.count", +1 do
      assert_no_difference "ScoreDispute.count" do
        post "/confirm/#{token.id}", params: params
        assert_response :ok
        assert_template 'submit_score_success'
      end
    end

    assert_equal 'open', ScoreDispute.last.status
  end

  private

  def confirm_params(report, token)
    {
      token: token.token,
      game_id: report.game_id,
      team_id: report.other_team.id,
      team_score: report.opponent_score,
      opponent_score: report.team_score,
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
