module Api
  class BaseController < ActionController::API
    include TournamentConcern

    force_ssl if: :ssl_configured?

    abstract!

    respond_to :json

    private

    def ssl_configured?
      Settings.ssl
    end
  end
end
