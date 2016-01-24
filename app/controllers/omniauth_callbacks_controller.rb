class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def callback
    user = User.from_omniauth(request.env['omniauth.auth'])
    sign_in(:user, user)

    if user.sign_in_count == 1 || !user.tournaments.exists?
      redirect_to setup_path
    else
      flash[:animate] = "fadeIn"
      redirect_to after_sign_in_path(user)
    end
  end

  ['google_oauth2', 'facebook'].each do |k|
    alias_method k, :callback
  end

  private

  def after_sign_in_path(user)
    return session[:previous_url] if session[:previous_url]
    return tournament_admin_path(session[:tournament_friendly_id]) if session[:tournament_friendly_id]
    if user.tournaments.count == 1
      tournament_admin_path(user.tournaments.first)
    else
      choose_tournament_path
    end
  end
end
