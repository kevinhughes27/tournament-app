require 'test_helper'

class ScoreReportTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @game = games(:pheonix_mavericks)
  end

  test "home/away scores are correct if submitted by home team" do
    report = score_reports(:swift_goose)
    assert_equal 15, report.home_score
    assert_equal 11, report.away_score
  end

  test "home/away scores are correct if submitted by away team" do
    report = score_reports(:swift_goose_by_goose)
    assert_equal 15, report.home_score
    assert_equal 11, report.away_score
  end

  test "submitter_won? returns true if the submitter won the game" do
    assert score_reports(:swift_goose).submitter_won?
    refute score_reports(:swift_goose_by_goose).submitter_won?
  end

  test "other_team" do
    assert_equal teams(:goose), score_reports(:swift_goose).other_team
    assert_equal teams(:swift), score_reports(:swift_goose_by_goose).other_team
  end

  test "is soft deleted" do
    report = score_reports(:swift_goose_by_goose)
    report.destroy()
    assert report.deleted?
  end

  test "soft deleted objects not in query" do
    report = score_reports(:swift_goose_by_goose)
    report.destroy()
    assert_equal 1, @tournament.score_reports.all.size
  end

  test "creating a score report mails the other team" do
    ScoreReportMailer.expects(:notify_team_email).with(
      @game.away,
      @game.home,
      instance_of(ScoreReport),
      instance_of(ScoreReportConfirmToken)
    ).returns(stub(:deliver_later))

    report = ScoreReport.create!(score_report_params)
  end

  test "creating a score report from confirmation doesn't mail the other team" do
    ScoreReportMailer.expects(:notify_team_email).never
    report = ScoreReport.create!(score_report_params.merge(is_confirmation: true))
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
