class SubmitScoreReport < MutationOperation
  property :game_id
  property :team_id
  property :submitter_fingerprint
  property :team_score
  property :opponent_score
  property :rules_knowledge
  property :fouls
  property :fairness
  property :attitude
  property :communication
  property :comments

  def execute
    raise unless valid_submitter?
    report.save!
    notify_other_team
    confirm_game
  end

  private

  def report
    @report ||= ScoreReport.new(
      tournament_id: tournament.id,
      game_id: game_id,
      team_id: team_id,
      submitter_fingerprint: submitter_fingerprint,
      team_score: team_score,
      opponent_score: opponent_score,
      rules_knowledge: rules_knowledge,
      fouls: fouls,
      fairness: fairness,
      attitude: attitude,
      communication: communication,
      comments: comments
    )
  end

  def game
    @game ||= Game.find(game_id)
  end

  def valid_submitter?
    game.home == report.team || game.away == report.team
  end

  def notify_other_team
    token = ScoreReportConfirmToken.create!({
      tournament_id: report.tournament_id,
      score_report_id: report.id
    })

    ScoreReportMailer.notify_team_email(
      report.other_team,
      report.team,
      report,
      report.confirm_token
    ).deliver_later
  end

  def confirm_game
    return if confirm_setting == 'validated'
    return if confirm_setting == 'multiple' && game.score_reports.size < 2

    if matches_other_reports?
      GameUpdateScore.perform(
        game: game,
        home_score: report.home_score,
        away_score: report.away_score,
        force: true
      )
    elsif game.score_disputes.blank?
      ScoreDispute.create!(
        tournament_id: report.tournament_id,
        game_id: report.game_id
      )
    end

    game.update(updated_at: Time.now)
  end

  def confirm_setting
    tournament.game_confirm_setting
  end

  def matches_other_reports?
    game.score_reports.all? { |r| report.eql?(r) }
  end
end
