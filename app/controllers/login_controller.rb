class LoginController < Devise::SessionsController
  skip_before_action :require_no_authentication
  prepend_view_path 'app/views/login'
  layout 'login'

  def new
    clear_session if from_brochure?
    super
  end

  def choose_tournament
    if request.post?
      tournament = Tournament.friendly.find(params[:tournament])
      flash[:animate] = "fadeIn"
      redirect_to tournament_admin_path(tournament)
    end
  end

  def create
    user = warden.authenticate!(auth_options)
    return redirect_to setup_path unless user.tournaments.exists?

    if session[:tournament_id].blank?
      login_no_tournament_id(user)
    elsif user.is_tournament_user?(session[:tournament_id])
      login(user)
    else
      flash.now[:alert] = "Invalid login for tournament."
      redirect_to_login
    end
  end

  def destroy
    super do
      clear_session
    end
  end

  private

  def login_no_tournament_id(user)
    sign_in(:user, user)

    if user.tournaments.count == 1
      flash[:animate] = "fadeIn"
      respond_with user, location: tournament_admin_path(user.tournaments.first)
    else
      redirect_to choose_tournament_path
    end
  end

  def login(user)
    sign_in(:user, user)
    flash[:animate] = "fadeIn"
    respond_with user, location: after_login_in_path
  end

  def from_brochure?
    referer == root_url
  end

  def referer
    request.env['HTTP_REFERER']
  end

  def user_params
    params.require(:user).except(:password).permit(:email)
  end

  def clear_session
    session.delete(:tournament_id)
    session.delete(:tournament_friendly_id)
  end

  def redirect_to_login
    self.resource = User.new(user_params)
    render :new
  end

  def after_login_in_path
    session[:previous_url] || tournament_admin_path(session[:tournament_friendly_id])
  end
end
