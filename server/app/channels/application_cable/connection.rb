module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_tournament

    def connect
      self.current_tournament = find_verified_tournament
    end

    protected

    def find_verified_tournament
      verified_tournament = Tournament.find_by(id: cookies.signed['tournament.id'])
      if verified_tournament && cookies.signed['tournament.expires_at'] > Time.now
        verified_tournament
      else
        reject_unauthorized_connection
      end
    end
  end
end
