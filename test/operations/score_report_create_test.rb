require 'test_helper'

class ScoreReportCreateTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @game = games(:pheonix_mavericks)
  end

  test "creating a score report mails the other team" do
    ScoreReportMailer.expects(:notify_team_email).with(
      @game.away,
      @game.home,
      instance_of(ScoreReport),
      instance_of(ScoreReportConfirmToken)
    ).returns(stub(:deliver_later))

    ScoreReportCreate.perform(
      score_report_params,
      @tournament.game_confirm_setting
    )
  end

  test "creating a score report from confirmation doesn't mail the other team" do
    ScoreReportMailer.expects(:notify_team_email).never

    create = ScoreReportCreate.new(
      score_report_params,
      @tournament.game_confirm_setting
    )
    create.agrees = true
    create.perform
  end

  private

  def score_report_params
    {
      tournament_id: @tournament.id,
      game_id: @game.id,
      team_id: @game.home.id,
      submitter_fingerprint: 'fingerprint',
      team_score: 15,
      opponent_score: 13,
      rules_knowledge: 3,
      fouls: 3,
      fairness: 3,
      attitude: 3,
      communication: 3,
      comments: 'comment'
    }
  end
end
