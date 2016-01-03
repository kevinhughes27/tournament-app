class TournamentsController < ApplicationController
  before_action :authenticate_user!
  before_action :load_tournament, only: [:show, :update]
  layout 'builder'

  def new
    @tournament = Tournament.new
  end

  def create
    Tournament.transaction do
      @tournament = Tournament.create!(tournament_params)
      TournamentUser.create!(tournament_id: @tournament.id, user_id: current_user.id)
    end

    redirect_to tournament_path(@tournament.id)
  end

  def show
  end

  def update
  end

  private

  def tournament_params
    params.require(:tournament).permit(
      :name,
      :handle,
      :description,
      :time_cap,
      map_attributes: [:lat, :long, :zoom]
    )
  end

  def load_tournament
    @tournament = Tournament.find(params[:id])
  end

end
