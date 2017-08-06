module Api
  class BaseController < ActionController::API
    include TournamentConcern

    before_action :cors

    force_ssl if: :ssl_configured?

    abstract!

    respond_to :json

    private

    def cors
      headers['Access-Control-Allow-Origin'] = '*'
    end

    def ssl_configured?
      Settings.ssl
    end
  end
end
