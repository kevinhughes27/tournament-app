class ScoreReportsController < ApplicationController
  include LoadTournament

  before_action :load_token, only: [:confirm_get, :confirm_post]
  skip_before_action :verify_authenticity_token, :only => [:submit]

  layout 'app'

  def submit
    create = ScoreReportCreate.new(
      report_params,
      @tournament.game_confirm_setting
    )
    create.perform

    if create.succeeded?
      render json: true
    else
      render json: create.errors, status: :unprocessable_entity
    end
  end

  def confirm_get
    @report = @token.score_report
    render 'confirm', locals: {confirm_token: @token, report: @report}
  end

  def confirm_post
    confirm = ScoreReportConfirm.new(
      @token,
      report_params,
      @tournament.game_confirm_setting
    )
    confirm.perform

    if confirm.succeeded?
      render confirm.agrees? ? 'confirm_score_success' : 'submit_score_success'
    else
      render 'confirm_score_error', status: :unprocessable_entity
    end
  end

  private

  def load_token
    @token = ScoreReportConfirmToken.find_by(id: params[:id], token: params[:token])
    if @token.blank?
      render 'token_not_found', status: :not_found
    end
  end

  def report_params
    @report_params ||= params.permit(
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

    @report_params[:tournament_id] = @tournament.id
    @report_params
  end
end
