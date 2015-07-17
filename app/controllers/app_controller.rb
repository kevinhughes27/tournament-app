class AppController < ApplicationController
  layout 'app'

  def show
    @tournament = Tournament.friendly.find(params[:tournament_id])

    @map = @tournament.map
    @fields = @tournament.fields
    @teams = @tournament.teams
    @games = @tournament.games

    render :show
  end

  def score_submit
    # do stuff with the post
    # byebug
    render json: true
  end

end
