require 'test_helper'

class SubmitScoreReportTest < ActiveSupport::TestCase
  setup do
    @tournament = FactoryGirl.create(:tournament)
    @context = {tournament: @tournament}
    @game = FactoryGirl.create(:game)
  end

  test 'submitting a score report emails the other team' do
    ScoreReportMailer.expects(:notify_team_email).with(
      @game.away,
      @game.home,
      instance_of(ScoreReport),
      instance_of(ScoreReportConfirmToken)
    ).returns(stub(:deliver_later))

    SubmitScoreReport.call({}, score_report_params, @context)
  end

  test 'submitting a score report creates a score report' do
    assert_difference "ScoreReport.count", +1 do
      SubmitScoreReport.call({}, score_report_params, @context)
    end
  end

  test 'when tournament confirm_setting is automatic' do
    @tournament.update_columns(game_confirm_setting: 'automatic')
    SubmitScoreReport.call({}, score_report_params, @context)
    assert @game.reload.score_confirmed
  end

  test 'when tournament confirm_setting is validated' do
    @tournament.update_columns(game_confirm_setting: 'validated')
    SubmitScoreReport.call({}, score_report_params, @context)
    refute @game.reload.score_confirmed
  end

  test 'when tournament confirm_setting is multiple and both teams submit' do
    @tournament.update_columns(game_confirm_setting: 'multiple')
    SubmitScoreReport.call({}, score_report_params, @context)
    refute @game.reload.score_confirmed

    second_report_params = score_report_params.merge(
      team_id: @game.away.id,
      submitter_fingerprint: 'fingerprint2'
    )

    SubmitScoreReport.call({}, second_report_params, @context)
    assert @game.reload.score_confirmed
  end

  test 'when tournament confirm_setting is multiple and one team submits twice' do
    @tournament.update_columns(game_confirm_setting: 'multiple')
    SubmitScoreReport.call({}, score_report_params, @context)
    refute @game.reload.score_confirmed

    second_report_params = score_report_params.merge(
      submitter_fingerprint: 'fingerprint2'
    )

    SubmitScoreReport.call({}, second_report_params, @context)
    refute @game.reload.score_confirmed
  end

  test 'when tournament confirm_setting is multiple and one device submits twice' do
    @tournament.update_columns(game_confirm_setting: 'multiple')
    SubmitScoreReport.call({}, score_report_params, @context)
    refute @game.reload.score_confirmed

    second_report_params = score_report_params.merge(
      team_id: @game.away.id
    )

    SubmitScoreReport.call({}, second_report_params, @context)
    refute @game.reload.score_confirmed
  end

  test 'when tournament confirm_setting is multiple and reports dont match' do
    @tournament.update_columns(game_confirm_setting: 'multiple')
    SubmitScoreReport.call({}, score_report_params, @context)
    refute @game.reload.score_confirmed

    second_report_params = score_report_params.merge(
      team_id: @game.away.id,
      submitter_fingerprint: 'fingerprint2',
      home_score: 3,
      away_score: 15
    )

    SubmitScoreReport.call({}, second_report_params, @context)
    refute @game.reload.score_confirmed
  end

  [:automatic, :multiple].each do |setting|
    test "reporting a different score creates a dispute with confirm setting #{setting}" do
      @tournament.update_columns(game_confirm_setting: setting)
      SubmitScoreReport.call({}, score_report_params, @context)

      second_report_params = score_report_params.merge(
        home_score: 3,
        away_score: 15
      )

      assert_difference "ScoreDispute.count", +1 do
        SubmitScoreReport.call({}, second_report_params, @context)
      end
    end
  end

  test 'doesnt create a second score dispute' do
    SubmitScoreReport.call({}, score_report_params, @context)

    second_report_params = score_report_params.merge(
      home_score: 3,
      away_score: 15
    )

    assert_difference "ScoreReport.count", +2 do
      assert_difference "ScoreDispute.count", +1 do
        SubmitScoreReport.call({}, second_report_params, @context)
        SubmitScoreReport.call({}, second_report_params, @context)
      end
    end
  end

  private

  def score_report_params
    {
      game_id: @game.id,
      team_id: @game.home.id,
      submitter_fingerprint: 'fingerprint',
      home_score: 15,
      away_score: 13,
      rules_knowledge: 3,
      fouls: 3,
      fairness: 3,
      attitude: 3,
      communication: 3,
      comments: 'comment'
    }
  end
end
