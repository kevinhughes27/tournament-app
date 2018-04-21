class Admin::SettingsController < AdminController

  def show
  end

  def update
    input = params_to_input(tournament_params, params)

    result = execute_graphql(
      'settingsUpdate',
      'SettingsUpdateInput',
      input,
      "{
         success,
         confirm
       }"
    )

    if result['success']
      flash[:notice] = 'Settings saved.'
      redirect_to admin_settings_url(subdomain: @tournament.handle)
    elsif result['confirm']
      render partial: 'confirm_update', status: :unprocessable_entity
    else
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
      :score_submit_pin,
      :game_confirm_setting
    )

    tournament_params[:timezone] = Time.zone.name
    tournament_params
  end
end
