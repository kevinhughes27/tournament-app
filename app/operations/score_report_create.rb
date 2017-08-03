class ScoreReportCreate < ApplicationOperation
  input :params
  input :confirm_setting, accepts: String, required: true
  property :agrees, accepts: [true, false], default: false

  attr_reader :game, :report

  class Failed < StandardError
    attr_reader :errors

    def initialize(report, *args)
      @errors = report.errors.full_messages
      super('ScoreReportCreate failed.', *args)
    end
  end

  def execute
    @report = ScoreReport.new(params)
    @game = @report.game

    raise unless valid_submitter?

    unless report.save
      errors = report.errors.full_messages

      e = Exception.new(errors.to_json)
      Rollbar.error(e)

      raise Failed(errors)
    end

    notify_other_team
    confirm_game
  end

  private

  def valid_submitter?
    game.home == report.team || game.away == report.team
  end

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
