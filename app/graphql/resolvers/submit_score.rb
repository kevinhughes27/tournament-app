class Resolvers::SubmitScore < Resolver
  def call(inputs, ctx)
    @tournament = ctx[:tournament]
    @game = @tournament.games.find(inputs[:game_id])
    @report = build_report(inputs)

    if !valid_submitter?
      return { success: false }
    end

    if @report.save
      notify_other_team
      confirm_game(ctx)
      { success: true }
    else
      { success: false }
    end
  end

  private

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

  def valid_submitter?
    @game.home == @report.team || @game.away == @report.team
  end

  def notify_other_team
    ScoreReportMailer.notify_team_email(
      @report.other_team,
      @report.team,
      @report
    ).deliver_later
  end

  def confirm_game(ctx)
    return if confirm_setting == 'multiple' && @game.score_reports.size < 2

    if matches_other_reports?
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
end
