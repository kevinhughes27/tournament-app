module JWTController
  extend ActiveSupport::Concern

  included do
    include Knock::Authenticable
  end

  # overwrite current_user added by devise with
  # a method for knock (gem would add this if it were not already defined)
  # https://github.com/nsarno/knock/issues/220
  def current_user
    @current_user ||= begin
      Knock::AuthToken.new(token: token).entity_for(User)
    rescue Knock.not_found_exception_class, JWT::DecodeError
      nil
    end
  end
end
