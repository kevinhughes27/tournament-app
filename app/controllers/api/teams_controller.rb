module Api
  class TeamsController < BaseController
    def index
      teams = @tournament.teams
      render json: teams
    end
  end
end
