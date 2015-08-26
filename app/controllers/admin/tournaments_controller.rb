class Admin::TournamentsController < AdminController
  skip_before_filter :load_tournament, only: [:create]

  def show
  end

  def update
    if @tournament.update(tournament_params)
      render :show, notice: 'Tournament was successfully updated.', turolinks: true
    else
      render :show
    end
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
end
