class Admin::SettingsController < AdminController
  before_action :check_update_safety, only: [:update]

  def show
  end

  def update
    if @tournament.update(tournament_params)
      flash[:notice] = 'Settings saved.'
      redirect_to admin_settings_url(subdomain: @tournament.handle)
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

  def check_update_safety
    return if params[:confirm] == 'true'
    return if @tournament.handle == tournament_params[:handle]

    @tournament.assign_attributes(tournament_params)
    render partial: 'confirm_update', status: :unprocessable_entity
  end

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
