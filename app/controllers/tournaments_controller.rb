class TournamentsController < ApplicationController
  before_action :authenticate_user!
  layout 'builder'

  def new
    @tournament = Tournament.new
  end

  def create
    @tournament = Tournament.new(tournament_create_params)

    Tournament.transaction do
      @tournament.save!
      TournamentUser.create!(tournament_id: @tournament.id, user_id: current_user.id)
    end

    redirect_to tournament_build_path(@tournament.id, :step1)

  rescue ActiveRecord::RecordInvalid => e
    render :new
  end

  private

  def tournament_create_params
    params.require(:tournament).permit(
      :name,
      :handle,
    )
  end
end
