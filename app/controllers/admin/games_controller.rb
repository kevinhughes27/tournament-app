class Admin::GamesController < AdminController
  def index
    @games = @tournament.games.includes(:home, :away, :division, score_reports: [:team])
  end

  def update
    @game = Game.find(params[:id])

    home_score = params[:home_score].to_i
    away_score = params[:away_score].to_i
    force = params[:force] == 'true'

    if update_score(@game, home_score, away_score, force)
      head :ok
    else
      head :unprocessable_entity
    end
  end

  private

  def update_score(game, home_score, away_score, force)
    Games::UpdateScoreJob.perform_now(
      game: game,
      home_score: home_score,
      away_score: away_score,
      force: force
    )
  end
end
