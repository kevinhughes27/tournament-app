class Admin::SettingsController < AdminController

  def show
  end

  def update
    if @tournament.update(tournament_params)
      flash[:notice] = 'Settings saved.'
    else
      flash[:error] = 'Error saving Settings.'
    end

    redirect_to tournament_admin_settings_path(@tournament)
  end

  private

  def tournament_params
    params.require(:tournament).permit(
      :name,
      :handle,
      :time_cap
    )
  end
end
