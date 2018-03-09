require 'test_helper'

class ScoreReportMailerTest < ActionMailer::TestCase
  test "notify_team_email" do
    report = FactoryGirl.create(:score_report)
    team = report.team
    other_team = report.other_team

    email = ScoreReportMailer.notify_team_email(other_team, team, report).deliver_now

    assert_equal ['no-reply@ultimate-tournament.io'], email.from
    assert_equal [other_team.email], email.to
    assert_equal 'Opponent Score Submission', email.subject
    assert email.body.to_s
  end
end
