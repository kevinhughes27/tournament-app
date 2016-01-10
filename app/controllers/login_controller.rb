class LoginController < Devise::SessionsController
  before_action :set_tournament, only: [:create]

  def new
    clear_session if from_brochure?
    super
  end

  def create
    user = warden.authenticate!(auth_options)

    if user.is_tournament_user?(session[:tournament_id])
      sign_in(:user, user)
      flash[:animate] = "fadeIn"
      respond_with user, location: after_sign_in_path_for(user)
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

  def from_brochure?
    referer == root_url
  end

  def referer
    request.env['HTTP_REFERER']
  end

  def set_tournament
    return unless params[:tournament]
    tournament = Tournament.friendly.find(params[:tournament])

    session[:tournament_id] = tournament.id
    session[:tournament_friendly_id] = tournament.friendly_id

  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Invalid tournament.'
    redirect_to_login
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

  def after_sign_in_path_for(user)
    session[:previous_url] || tournament_admin_path(session[:tournament_friendly_id])
  end
end
