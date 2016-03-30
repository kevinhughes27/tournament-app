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
    if tournament_subdomain
      return admin_url(subdomain: tournament_subdomain) + session[:previous_path].to_s
    end

    if user.tournaments.count == 1
      tournament = user.tournaments.first
      admin_url(subdomain: tournament.handle)
    else
      choose_tournament_path
    end
  end

  def tournament_subdomain
    subdomain unless subdomain == 'www'
  end

  def subdomain
    parts = URI.parse(omniauth_origin).host.split('.')
    parts.size == 3 ? parts.first : nil
  end

  def omniauth_origin
    request.env['omniauth.origin']
  end
end
