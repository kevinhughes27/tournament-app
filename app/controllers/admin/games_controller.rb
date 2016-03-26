class Admin::GamesController < AdminController
  respond_to :json, only: [:update]

  def index
    @games = @tournament.games.includes(:home, :away, :field, :division, score_reports: [:team])
  end

  def update
    @game = Game.find(params[:id])

    home_score = params[:home_score].to_i
    away_score = params[:away_score].to_i

    @game.update_score(home_score, away_score)
  end
end
