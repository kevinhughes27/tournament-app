class ScoreReportsController < ApplicationController
  include LoadTournament

  before_action :load_confirm_token, only: [:confirm]

  layout 'app'

  def submit
    report = ScoreReport.new(score_report_params)
    if report.save
      render json: true
    else
      render json: report.errors.full_messages, status: :unprocessable_entity
    end
  end

  def confirm
    if request.post?
      ScoreReport.create!(
        score_report_params.merge(is_confirmation: is_confirmation)
      )
      render is_confirmation ? 'confirm_score_success' : 'submit_score_success'
    else
      @report = @confirm_token.score_report
    end
  end

  private

  def load_confirm_token
    @confirm_token = ScoreReportConfirmToken.find_by(id: params[:id], token: params[:token])
    if @confirm_token.blank?
      render 'token_not_found', status: :not_found
    end
  end

  def is_confirmation
    @is_confirmation ||= begin
      first_report = @confirm_token.score_report

      first_report.opponent_score.to_s == score_report_params[:team_score] &&
      first_report.team_score.to_s == score_report_params[:opponent_score]
    end
  end

  def score_report_params
    @score_report_params ||= params.permit(
      :game_id,
      :team_id,
      :submitter_fingerprint,
      :team_score,
      :opponent_score,
      :rules_knowledge,
      :fouls,
      :fairness,
      :attitude,
      :communication,
      :comments,
    )

    @score_report_params[:tournament_id] = @tournament.id
    @score_report_params
  end
end
