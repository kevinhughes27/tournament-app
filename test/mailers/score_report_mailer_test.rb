require 'test_helper'

class ScoreReportMailerTest < ActionMailer::TestCase
  test "notify_team_email" do
    email = ScoreReportMailer.notify_team_email(
      teams(:goose),
      teams(:swift),
      score_reports(:swift_goose),
      score_report_confirm_tokens(:goose_confirm_token)
    ).deliver_now

    assert_equal ['no-reply@ultimate-tournament.io'], email.from
    assert_equal ['goose@losers.com'], email.to
    assert_equal 'Opponent Score Submission', email.subject
    assert email.body.to_s
  end
end
