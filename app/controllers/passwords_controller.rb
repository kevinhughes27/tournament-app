class PasswordsController < Devise::PasswordsController
  prepend_view_path 'app/views/passwords'
  layout 'login'

  def after_sending_reset_password_instructions_path_for(user)
    flash[:info] = 'Password reset email sent.'
    new_user_password_path
  end

  def after_resetting_password_path_for(user)
    new_user_session_path
  end
end
