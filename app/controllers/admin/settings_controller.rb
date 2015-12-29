class Admin::SettingsController < AdminController
  skip_before_action :load_tournament
  before_action :load_tournament_with_map

  def show
  end

  def update
    if @tournament.update(tournament_params)
      flash[:notice] = 'Settings saved.'
    else
      flash[:error] = 'Error saving settings.'
    end

    redirect_to tournament_admin_settings_path(@tournament)
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
