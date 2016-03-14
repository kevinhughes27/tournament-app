class Admin::MapController < AdminController
  include LoadTournamentWithMap

  def show
  end

  def update
    if @tournament.update(tournament_params)
      head :ok
    else
      head :unproccesible_entiry
    end
  end

  private

  def tournament_params
    params.require(:tournament).permit(
      map_attributes: [:lat, :long, :zoom]
    )
  end
end
