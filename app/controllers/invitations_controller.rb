class InvitationsController < Devise::InvitationsController
  skip_before_action :require_no_authentication

  layout 'login'

  def after_accept_path_for(user)
    # invited user will always have exactly 1 tournament
    user.tournaments.first.admin_url
  end
end
