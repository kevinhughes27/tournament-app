module Api
  class GamesController < BaseController
    def index
      games = @tournament.games.includes(:home, :away, :field, :division)
      render json: games, include: [:home, :away, :field, :division]
    end
  end
end
