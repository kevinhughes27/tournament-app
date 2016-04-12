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
    tournament_params = params.require(:tournament).permit(
      map_attributes: [:id, :lat, :long, :zoom]
    )

    tournament_params[:map_attributes][:edited_at] = Time.now
    tournament_params
  end
end
