class SignupController < Devise::RegistrationsController
  respond_to :json
  def after_sign_in_path_for(resource); end
end
