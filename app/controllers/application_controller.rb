class ApplicationController < ActionController::Base
  abstract!

  layout :layout_by_resource
  protect_from_forgery with: :exception, prepend: true

  def set_jwt_cookie(user)
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    cookies['jwt'] = {
      value: token,
      domain: :all,
      tld_length: 2
    }
  end

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
