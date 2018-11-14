module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_tournament

    def connect
      self.current_tournament = find_verified_tournament
    end

    protected

    def find_verified_tournament
      verified_tournament = find_from_cookie || find_from_params

      if verified_tournament
        verified_tournament
      else
        reject_unauthorized_connection
      end
    end

    private

    def find_from_cookie
      return unless cookies.signed['tournament.id'] && cookies.signed['tournament.expires_at'] > Time.now
      Tournament.find(cookies.signed['tournament.id'])
    end

    def find_from_params
      return unless request.params[:handle]
      Tournament.find_by(handle: request.params[:handle])
    end
  end
end
