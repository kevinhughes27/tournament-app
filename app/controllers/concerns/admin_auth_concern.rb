module AdminAuthConcern
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!
    before_action :authenticate_tournament_user!
  end

  protected

  def authenticate_tournament_user!
    unless current_user.is_tournament_user?(@tournament.id) || current_user.staff?
      redirect_to new_user_session_path
    end
  end
end
