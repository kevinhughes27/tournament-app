class ScoreReportConfirm < ApplicationOperation
  input :token, accepts: ScoreReportConfirmToken, required: true
  input :params
  input :confirm_setting, accepts: String, required: true

  def execute
    create = ScoreReportCreate.new(params, confirm_setting)
    create.agrees = agrees?
    create.perform
    fail unless create.succeeded?
  end

  def agrees?
    @agrees ||= begin
      first_report = token.score_report

      first_report.opponent_score.to_s == params[:team_score] &&
      first_report.team_score.to_s == params[:opponent_score]
    end
  end
end
