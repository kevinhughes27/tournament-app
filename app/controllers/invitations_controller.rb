class InvitationsController < Devise::InvitationsController
  def after_accept_path_for(resource)
    byebug
  end
end
