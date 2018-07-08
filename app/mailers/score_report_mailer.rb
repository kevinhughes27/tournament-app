class ScoreReportMailer < ApplicationMailer
  def notify_team_email(report)
    team_to_notify = report.other_team
    return unless team_to_notify && team_to_notify.email.present?

    @team = team_to_notify
    @opponent = report.team
    @report = report
    @tournament = @report.tournament

    @outcome = @report.submitter_won? ? 'loss' : 'win'
    @confirm_link = @report.build_confirm_link
    @dispute_link = @report.build_dispute_link

    mail(to: @team.email, subject: "Opponent Score Submission")
  end
end
