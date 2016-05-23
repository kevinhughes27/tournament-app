class AppController < ApplicationController
  include LoadTournament

  before_action :set_tournament_timezone
  before_action :load_confirm_token, only: [:confirm]

  layout 'app'

  def show
    @map = @tournament.map
    @fields = @tournament.fields.sort_by{|f| f.name.gsub(/\D/, '').to_i }
    @teams = @tournament.teams
    @games = @tournament.games
               .assigned
               .with_teams
               .includes(:home, :away, :field, :division)

    render :show
  end

  def score_submit
    report = ScoreReport.new(score_report_params)
    if report.save
      render json: true
    else
      render json: report.errors.full_messages, status: :unprocessable_entity
    end
  end

  def confirm
    if request.post?
      ScoreReport.create!(score_report_params.merge(is_confirmation: true))
      render 'confirm_score_success'
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

  # this can still be overridden by the user's timezone cookie
  def set_tournament_timezone
    Time.zone = @tournament.timezone
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
