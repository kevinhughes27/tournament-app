class SubmitScoreReport < MutationOperation
  input :game_id, type: :keyword
  input :team_id, type: :keyword
  input :submitter_fingerprint, type: :keyword
  input :home_score, type: :keyword
  input :away_score, type: :keyword
  input :rules_knowledge, type: :keyword
  input :fouls, type: :keyword
  input :fairness, type: :keyword
  input :attitude, type: :keyword
  input :communication, type: :keyword
  input :comments, type: :keyword

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
      home_score: home_score,
      away_score: away_score,
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
    ScoreReportMailer.notify_team_email(
      report.other_team,
      report.team,
      report
    ).deliver_later
  end

  def confirm_game
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
    if confirm_setting == 'multiple'
      both_teams_submitted = game.score_reports.map(&:team_id).uniq.count == 2
      return false unless both_teams_submitted

      multiple_devices_submitted = game.score_reports.map(&:submitter_fingerprint).uniq.count > 1
      return false unless multiple_devices_submitted
    end

    game.score_reports.all? { |r| report.eql?(r) }
  end
end
