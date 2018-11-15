module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_tournament

    def connect
      self.current_tournament = find_verified_tournament
    end

    protected

    def find_verified_tournament
      if verified_tournament = Tournament.find_by(handle: request.subdomain)
        verified_tournament
      else
        reject_unauthorized_connection
      end
    end
  end
end
