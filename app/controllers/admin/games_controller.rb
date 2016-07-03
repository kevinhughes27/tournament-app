class Admin::GamesController < AdminController
  def index
    @games = @tournament.games.includes(
      :home,
      :away,
      :division,
      :score_disputes,
      score_reports: [:team]
    )
  end

  def update
    @game = Game.find(params[:id])

    home_score = params[:home_score].to_i
    away_score = params[:away_score].to_i
    force = params[:force] == 'true'
    resolve = params[:resolve] == 'true'

    @game.resolve_disputes! if resolve

    if update_score(@game, home_score, away_score, force)
      create_score_entry(@game, home_score, away_score)
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

  def create_score_entry(game, home_score, away_score)
    ScoreEntry.create!(
      tournament: @tournament,
      user: current_user,
      game: game,
      home: game.home,
      away: game.away,
      home_score: home_score,
      away_score: away_score
    )
  end
end
