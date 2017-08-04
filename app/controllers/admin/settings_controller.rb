class Admin::SettingsController < AdminController

  def show
  end

  def update
    UpdateSettings.perform(@tournament, tournament_params, params[:confirm])
    flash[:notice] = 'Settings saved.'
    redirect_to admin_settings_url(subdomain: @tournament.handle)
  rescue ConfirmationRequired
    render partial: 'confirm_update', status: :unprocessable_entity
  rescue StandardError
    render :show
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
      :game_confirm_setting
    )

    tournament_params[:timezone] = Time.zone.name
    tournament_params
  end
end
