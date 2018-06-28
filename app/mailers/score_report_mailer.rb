class ScoreReportMailer < ApplicationMailer
  def notify_team_email(team, opponent, report)
    return unless team.email.present?
    @team, @opponent, @report = team, opponent, report
    @tournament = @team.tournament
    @confirm_link = build_confirm_link
    @dispute_link = build_dispute_link
    mail(to: team.email, subject: "Opponent Score Submission")
  end

  private

  def build_confirm_link
    params = {
      teamName: @team.name,
      gameId: @report.game_id,
      homeScore: @report.home_score,
      awayScore: @report.away_score
    }

    "#{@tournament.domain}/submit?#{params.to_query}"
  end

  def build_dispute_link
    params = {
      teamName: @team.name,
      gameId: @report.game_id
    }

    "#{@tournament.domain}/submit?#{params.to_query}"
  end
end
