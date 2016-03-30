class LoginController < Devise::SessionsController
  before_action :sign_out_user, only: [:new]
  before_action :load_tournament, only: [:new, :create]

  skip_before_action :require_no_authentication
  skip_before_action :verify_signed_out_user

  prepend_view_path 'app/views/login'
  layout 'login'

  def choose_tournament
    if request.post?
      tournament = Tournament.friendly.find(params[:tournament])
      flash[:animate] = "fadeIn"
      redirect_to admin_url(subdomain: tournament.handle)
    end
  end

  def create
    user = warden.authenticate!(auth_options)
    return redirect_to setup_path unless user.tournaments.exists?

    if @tournament.nil?
      login_no_tournament_id(user)
    elsif user.is_tournament_user?(@tournament.id)
      login(user)
    else
      flash.now[:alert] = "Invalid login for tournament."
      redirect_to_login
    end
  end

  def destroy
    sign_out(current_user)
    session.delete(:tournament_id)
    session.delete(:tournament_friendly_id)

    redirect_to root_url(subdomain: '')
  end

  private

  def login_no_tournament_id(user)
    sign_in(:user, user)

    if user.tournaments.count == 1
      flash[:animate] = "fadeIn"
      tournament = user.tournaments.first
      respond_with user, location: admin_url(subdomain: tournament.handle)
    else
      redirect_to choose_tournament_path
    end
  end

  def login(user)
    sign_in(:user, user)
    flash[:animate] = "fadeIn"
    respond_with user, location: after_login_in_path
  end

  def sign_out_user
    return unless current_user
    sign_out(current_user)
  end

  def load_tournament
    return unless request.subdomain.present?
    @tournament = Tournament.friendly.find(request.subdomain)
  rescue ActiveRecord::RecordNotFound
    nil
  end

  def user_params
    params.require(:user).except(:password).permit(:email)
  end

  def redirect_to_login
    self.resource = User.new(user_params)
    render :new
  end

  def after_login_in_path
    admin_url(subdomain: @tournament.handle) + session[:previous_path].to_s
  end
end
