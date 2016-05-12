class Admin::GamesController < AdminController
  def index
    @games = @tournament.games.includes(:home, :away, :division, score_reports: [:team])
  end

  def update
    @game = Game.find(params[:id])

    home_score = params[:home_score].to_i
    away_score = params[:away_score].to_i

    if @game.update_score(home_score, away_score, force: params[:force])
      head :ok
    else
      head :unprocessable_entity
    end
  end
end
