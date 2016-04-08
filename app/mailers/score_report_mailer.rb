class ScoreReportMailer < ApplicationMailer
  default from: 'no-reply@ultimate-tournament.io'

  def notify_team_email(team, opponent, report, token)
    return unless team.email.present?
    @team, @opponent, @report, @token = team, opponent, report, token
    @tournament = @team.tournament
    mail(to: team.email, subject: "Opponent Score Submission")
  end
end
