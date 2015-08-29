class Admin::GamesController < AdminController

  def index
    @games = @tournament.games.includes(:home, :away, :field, :bracket, score_reports: [:team])
  end

  def update
    game = Game.find(params[:id])
    home_score = params[:home_score].to_i
    away_score = params[:away_score].to_i

    game.update_score(home_score, away_score)

    @games = [game, game.dependent_games].flatten
    change_keys = @games.map{ |g| "game:#{g.id}" }

    render :index, turbolinks: true, change: change_keys
  end

end
