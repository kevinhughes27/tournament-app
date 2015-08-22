class Admin::GamesController < AdminController

  def index
    @games = @tournament.games.includes(:home, :away, :field, :bracket)
  end

  def update
    game = Game.find(params[:id])
    home_score = params[:home_score].to_i
    away_score = params[:away_score].to_i

    if game.home_score && game.away_score
      game.update_score(home_score, away_score)
    else
      game.confirm_score(home_score, away_score)
    end

    @games = [game]
    render :index, turbolinks: true, change: "games:#{game.id}"
  end

end
