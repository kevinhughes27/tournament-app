class Admin::GamesController < AdminController
  before_action :load_games, only: :index
  before_action :load_game, only: :update

  def index
  end

  def update
    GameUpdateScore.perform(
      game: @game,
      user: current_user,
      home_score: params[:home_score],
      away_score: params[:away_score],
      force: params[:force] == 'true',
      resolve: params[:resolve] == 'true'
    )
    head :ok
  rescue => e
    render json: { error: update.message }, status: :unprocessable_entity
  end

  private

  def load_games
    @games = @tournament.games.includes(
      :home,
      :away,
      :division,
      :score_disputes,
      score_reports: [:team]
    )
  end

  def load_game
    @game = Game.find(params[:id])
  end
end
