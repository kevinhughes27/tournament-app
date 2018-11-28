class OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def callback
    user = User.from_omniauth(auth_hash)
    sign_in(:user, user)
    set_jwt_cookie(user)

    if for_internal_area?
      sign_in(:internal_user, user)
      return redirect_to internal_url
    end

    if user_needs_setup?(user)
      redirect_to setup_path
    else
      flash[:animate] = "fadeIn"
      redirect_to after_sign_in_path(user)
    end
  end

  alias_method :google_oauth2, :callback
  alias_method :facebook, :callback

  private

  def after_sign_in_path(user)
    if for_tournament_subdomain?
      return admin_url(subdomain: subdomain) + stored_path
    end

    if user_has_multiple_tournaments?(user)
      choose_tournament_path
    else
      tournament = user.tournaments.first
      admin_url(subdomain: tournament.handle)
    end
  end

  def user_needs_setup?(user)
    user.sign_in_count == 1 || !user.tournaments.exists?
  end

  def user_has_multiple_tournaments?(user)
    user.tournaments.count > 1
  end

  def for_internal_area?
    omniauth_origin.include?(new_internal_user_session_path) && current_user.staff?
  end

  def for_tournament_subdomain?
    subdomain && subdomain != 'www'
  end

  def stored_path
    stored_location_for(current_user).to_s.gsub('/admin', '')
  end

  def subdomain
    parts = URI.parse(omniauth_origin).host.split('.')
    parts.size == 3 ? parts.first : nil
  end

  def auth_hash
    request.env['omniauth.auth']
  end

  def omniauth_origin
    request.env['omniauth.origin']
  end
end
