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

  def reset_data
    @tournament.reset_data!
    flash[:notice] = 'Data reset.'
    redirect_to admin_settings_path
  end

  private

  def tournament_params
    tournament_params = params.require(:tournament).permit(
      :name,
      :handle,
      :time_cap
    )

    tournament_params[:timezone] = Time.zone.name
    tournament_params
  end
end
