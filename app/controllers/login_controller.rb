class LoginController < Devise::SessionsController
  before_action :set_tournament, only: [:create]

  def new
    clear_session if from_brochure?
    super
  end

  def create
    super do |user|
      flash[:animate] = "fadeIn"
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
    Thread.current[:tournament_id] = session[:tournament_id]

  rescue ActiveRecord::RecordNotFound
    flash[:alert] = 'Invalid tournament'
    redirect_to_login
  end

  def redirect_to_login
    self.resource = User.new(user_params)
    render :new
  end

  def user_params
    params.require(:user).except(:password).permit(:email)
  end

  def clear_session
    session.delete(:tournament_id)
    session.delete(:tournament_friendly_id)
  end

end
