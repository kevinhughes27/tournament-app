class AppController < ApplicationController
  layout 'app'

  def show
    @tournament = Tournament.friendly.find(params[:tournament_id])

    @map = @tournament.map
    @fields = @tournament.fields
    @teams = @tournament.teams
    @games = @tournament.games.includes(:home, :away, :field)

    render :show
  end

  def score_submit
    @tournament = Tournament.friendly.find(params[:tournament_id])
    ScoreReport.create!(score_report_params)
    render json: true
  end

  private

  def score_report_params
    @score_report_params ||= params.permit(
      :tournament_id,
      :game_id,
      :team_id,
      :team_score,
      :opponent_score,
      :rules_knowledge,
      :fouls,
      :fairness,
      :attitude,
      :communication,
    )

    @score_report_params[:tournament_id] = @tournament.id
    @score_report_params
  end

end
