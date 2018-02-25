class ActionController::TestCase
  include Devise::Test::ControllerHelpers

  def set_tournament(tournament)
    set_subdomain(tournament.try(:handle) || tournament)
  end

  def set_subdomain(subdomain)
    @request.host = "#{subdomain}.#{Settings.host}"
  end
end
