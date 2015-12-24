class Admin::SettingsController < AdminController

  def show
  end

  def update
    if @tournament.update(tournament_params)
      flash[:notice] = 'Settings saved.'
    else
      flash[:error] = 'Error saving settings.'
    end

    render :show
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
