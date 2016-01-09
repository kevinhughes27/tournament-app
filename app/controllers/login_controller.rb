class LoginController < Devise::SessionsController

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

  def clear_session
    session.delete(:tournament_id)
    session.delete(:tournament_friendly_id)
  end

end
