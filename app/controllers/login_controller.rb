class LoginController < Devise::SessionsController

  def new
    clear_session if from_sign_up?
    super
  end

  def create
    if params[:tournament]
      tournament = Tournament.friendly.find(params[:tournament])
      session[:tournament_id] = tournament.id
      session[:tournament_friendly_id] = tournament.friendly_id
    end

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

  def from_sign_up?
    referer == root_url
  end

  def referer
    request.env['HTTP_REFERER']
  end

  def clear_session
    session.delete(:tournament_id)
    session.delete(:tournament_friendly_id)
  end

end
