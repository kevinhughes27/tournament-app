class ApplicationController < ActionController::Base
  layout :layout_by_resource
  protect_from_forgery with: :exception
  before_action :copy_login_tournament_id_to_thread_current

  def layout_by_resource
    if devise_controller?
      false
    else
      'application'
    end
  end

  def copy_login_tournament_id_to_thread_current
    Thread.current[:login_tournament_id] = session[:login_tournament_id]
  end

  def after_sign_in_path_for(resource)
    tournament_admin_path(session[:login_tournament_friendly_id])
  end
end
