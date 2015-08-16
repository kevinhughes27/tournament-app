class Admin::GamesController < AdminController

  def index
    @games = @tournament.games.includes(:home, :away, :field, :bracket)
  end

  def update_score
    game = Game.find(params[:id])

    home_score = params[:home_score].to_i
    away_score = params[:away_score].to_i

    game.update_score(home_score, away_score)
    render json: game
  end

end
