class Admin::MapController < AdminController
  include LoadTournamentWithMap

  def show
  end

  def update
    if @tournament.update(tournament_params)
      flash[:notice] = 'Map saved.'
    else
      flash[:error] = 'Error saving Map.'
    end

    redirect_to admin_map_path, keep: '_map'
  end

  private

  def tournament_params
    params.require(:tournament).permit(
      map_attributes: [:lat, :long, :zoom]
    )
  end
end
