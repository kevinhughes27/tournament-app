module TournamentCableConcern
  extend ActiveSupport::Concern

  included do
    before_action :set_tournament_cookie
  end

  def set_tournament_cookie
    cookies.signed['tournament.id'] = {
      value: @tournament.id,
      domain: :all
    }
    cookies.signed['tournament.expires_at'] = {
      value: 30.minutes.from_now,
      domain: :all
    }
  end
end
