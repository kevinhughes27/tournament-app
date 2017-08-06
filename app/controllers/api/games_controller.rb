module Api
  class GamesController < BaseController
    def index
      @games = @tournament.games
        .scheduled
        .with_teams
        .includes(:home, :away, :field, :division)
    end
  end
end
