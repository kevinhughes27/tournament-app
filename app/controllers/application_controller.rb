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
end
