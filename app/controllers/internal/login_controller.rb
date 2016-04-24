class Internal::LoginController < Devise::SessionsController
  before_action :sign_out_user, only: [:new]
  skip_before_action :require_no_authentication
  skip_before_action :verify_signed_out_user

  def self.controller_path
    'login'
  end
  layout 'login'

  private

  def sign_out_user
    return unless current_user
    sign_out(current_user)
  end

  def after_sign_in_path_for(user)
    internal_url
  end
end
