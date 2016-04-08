class InternalController < ApplicationController
  before_action :store_location
  before_action :authenticate_user!
  before_action :ensure_staff

  layout 'internal'

  private

  def store_location
    return unless request.get?
    flash[:internal_path] = request.path
  end

  def ensure_staff
    redirect_to new_user_session_path unless current_user.staff?
  end
end
