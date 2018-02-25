class ScoreReportMailer < ApplicationMailer
  def notify_team_email(team, opponent, report)
    return unless team.email.present?
    @team, @opponent, @report = team, opponent, report
    @tournament = @team.tournament
    mail(to: team.email, subject: "Opponent Score Submission")
  end
end
