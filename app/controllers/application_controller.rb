class ApplicationController < ActionController::Base
  abstract!

  protect_from_forgery with: :exception, prepend: true

  def set_jwt_cookie(user)
    token = Knock::AuthToken.new(payload: { sub: user.id }).token
    cookies['jwt'] = {
      value: token,
      domain: :all,
      tld_length: 2
    }
  end
end
