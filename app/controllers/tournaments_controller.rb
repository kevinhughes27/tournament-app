class TournamentsController < ApplicationController
  before_action :authenticate_user!
  layout 'builder'

  def new
    @tournament = Tournament.new
  end

  def create
    Tournament.transaction do
      @tournament = Tournament.create!(tournament_create_params)
      TournamentUser.create!(tournament_id: @tournament.id, user_id: current_user.id)
    end

    if @tournament.persisted?
      redirect_to tournament_build_path(@tournament.id, :step1)
    else
      render :new
    end
  end

  private

  def tournament_create_params
    params.require(:tournament).permit(
      :name,
      :handle,
    )
  end
end
