class ApplicationController < ActionController::Base
  layout :layout_by_resource
  protect_from_forgery with: :exception

  def layout_by_resource
    if devise_controller?
      false
    else
      'application'
    end
  end

  def render_404
    respond_to do |format|
      format.html { render 'login/404', layout: 'login', status: :not_found }
      format.any  { head :not_found }
    end
  end
end
