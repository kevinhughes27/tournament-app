class Resolvers::SubmitScore < Resolvers::BaseResolver
  def call(inputs, ctx)
    @tournament = ctx[:tournament]
    @game = @tournament.games.find(inputs[:game_id])

    @report = load_or_build_report(inputs)

    success = if !(@game.teams_present?)
      false
    elsif !valid_submitter?
      false
    elsif save_report
      true
    else
      false
    end

    return {
      success: success,
      game_id: @game.id
    }
  end

  private

  def valid_submitter?
    @game.home_id == @report.team_id || @game.away_id == @report.team_id
  end

  def load_or_build_report(inputs)
    load_report(inputs) || build_report(inputs)
  end

  def load_report(inputs)
    report = @tournament.score_reports.find_by(
      game_id: @game.id,
      submitter_fingerprint: inputs[:submitter_fingerprint]
    )

    return unless report

    report = update_report(report, inputs)
    report
  end

  def update_report(report, inputs)
    report.team_id = inputs[:team_id]
    report.submitter_fingerprint = inputs[:submitter_fingerprint]
    report.home_score = inputs[:home_score]
    report.away_score = inputs[:away_score]
    report.rules_knowledge = inputs[:rules_knowledge]
    report.fouls = inputs[:fouls]
    report.fairness = inputs[:fairness]
    report.attitude = inputs[:attitude]
    report.communication = inputs[:communication]
    report.comments = inputs[:comments]

    report
  end

  def build_report(inputs)
    ScoreReport.new(
      tournament_id: @tournament.id,
      game_id: @game.id,
      team_id: inputs[:team_id],
      submitter_fingerprint: inputs[:submitter_fingerprint],
      home_score: inputs[:home_score],
      away_score: inputs[:away_score],
      rules_knowledge: inputs[:rules_knowledge],
      fouls: inputs[:fouls],
      fairness: inputs[:fairness],
      attitude: inputs[:attitude],
      communication: inputs[:communication],
      comments: inputs[:comments]
    )
  end

  def save_report
    if @report.save
      notify_other_team
      confirm_game
    end
  end

  def notify_other_team
    ScoreReportMailer.notify_team_email(@report).deliver_later
  end

  def confirm_game
    return if confirm_setting == 'multiple' && @game.score_reports.size < 2

    if matches_other_reports? && safe_to_update_score?
      SaveScore.perform(
        game: @game,
        home_score: @report.home_score,
        away_score: @report.away_score)
    elsif @game.score_disputes.blank?
      ScoreDispute.create!(
        tournament_id: @report.tournament_id,
        game_id: @report.game_id
      )
    end

    @game.update(updated_at: Time.now)
  end

  def confirm_setting
    @tournament.game_confirm_setting
  end

  def matches_other_reports?
    if confirm_setting == 'multiple'
      both_teams_submitted = @game.score_reports.map(&:team_id).uniq.count == 2
      return false unless both_teams_submitted

      multiple_devices_submitted = @game.score_reports.map(&:submitter_fingerprint).uniq.count > 1
      return false unless multiple_devices_submitted
    end

    @game.score_reports.all? { |r| @report.eql?(r) }
  end

  def safe_to_update_score?
    SafeToUpdateScoreCheck.perform(
      game: @game,
      home_score: @report.home_score,
      away_score: @report.away_score
    )
  end
end
