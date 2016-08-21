class ScoreReportCreate < ComposableOperations::Operation
  processes :params, :confirm_setting

  property :agrees, accepts: [true, false], default: false
  property :confirm_setting, accepts: String, required: true

  attr_reader :game, :report, :errors

  def execute
    @report = ScoreReport.new(params)
    @game = @report.game

    unless report.save
      @errors = report.errors.full_messages
      halt 'Save failed'
    end

    notify_other_team
    confirm_game
  end

  private

  def notify_other_team
    return if agrees

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
    return if confirm_setting == 'validated' && !agrees
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

  def matches_other_reports?
    game.score_reports.all? { |r| report.eql?(r) }
  end
end
