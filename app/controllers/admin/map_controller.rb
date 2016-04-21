class Admin::MapController < AdminController
  include LoadTournamentWithMap

  before_action :load_fields

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

  def load_fields
    @fields = @tournament.fields
  end

  def tournament_params
    tournament_params = params.require(:tournament).permit(
      map_attributes: [:id, :lat, :long, :zoom]
    )

    tournament_params[:map_attributes][:edited_at] = Time.now
    tournament_params
  end
end
