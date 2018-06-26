class LoginController < Devise::SessionsController
  before_action :sign_out_user, only: [:new]
  before_action :load_tournament, only: [:new, :create]

  skip_before_action :require_no_authentication
  skip_before_action :verify_signed_out_user
  skip_before_action :verify_authenticity_token, only: [:destroy]

  def self.controller_path
    'login'
  end
  layout 'login'

  def choose_tournament
    if request.post?
      tournament = Tournament.find_by!(handle: params[:tournament])
      flash[:animate] = "fadeIn"
      redirect_to admin_url(subdomain: tournament.handle)
    end
  end

  def create
    user = warden.authenticate!(auth_options)
    return redirect_to setup_path if (!user.staff? && user.tournaments.blank?)

    if @tournament.nil?
      login_no_tournament_id(user)
    elsif user.is_tournament_user?(@tournament.id) || user.staff?
      login(user)
    else
      flash.now[:alert] = "Invalid login for tournament."
      redirect_to_login
    end
  end

  def destroy
    sign_out(current_user)
    redirect_to root_url(subdomain: 'www')
  end

  private

  def login_no_tournament_id(user)
    if user_has_multiple_tournaments?(user)
      redirect_to choose_tournament_path
    else
      @tournament = user.tournaments.first
      login(user)
    end
  end

  def user_has_multiple_tournaments?(user)
    user.tournaments.count > 1
  end

  def login(user)
    flash[:animate] = "fadeIn"
    redirect_to after_login_in_path
  end

  def sign_out_user
    return unless current_user
    sign_out(current_user)
  end

  def load_tournament
    return unless request.subdomain.present?
    @tournament = Tournament.find_by!(handle: request.subdomain)
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
    stored_url_for_user || admin_url(subdomain: @tournament.handle)
  end

  def stored_url_for_user
    path = stored_location_for(current_user)
    @tournament.domain + path if path
  end
end
