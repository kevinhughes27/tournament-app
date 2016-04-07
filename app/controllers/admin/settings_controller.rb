class Admin::SettingsController < AdminController

  def show
  end

  def update
    if @tournament.update(tournament_params)
      flash[:notice] = 'Settings saved.'
      redirect_to admin_settings_path
    else
      flash[:error] = 'Error saving Settings.'
      render :show
    end
  end

  private

  def tournament_params
    tournament_params = params.require(:tournament).permit(
      :name,
      :handle,
      :time_cap
    )

    tournament_params.merge!(timezone: Time.zone.name)
    tournament_params
  end
end
