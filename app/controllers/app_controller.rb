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
    render json: true
  end

  private

  def score_report_params
    params
  end

end
