class InternalController < ApplicationController
  abstract!

  layout 'internal'

  before_action :authenticate_user!
  before_action :authenticate_staff!

  alias_method :current_user, :current_internal_user

  protected

  def authenticate_user!
    redirect_to new_internal_user_session_url unless internal_user_signed_in?
  end

  private

  def authenticate_staff!
    redirect_to new_internal_user_session_url unless current_internal_user.staff?
  end
end
