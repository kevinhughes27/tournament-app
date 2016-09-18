class Admin::GamesController < AdminController
  before_action :load_games, only: :index
  before_action :load_game, only: :update

  def index
  end

  def update
    update = GameUpdateScore.new(
      game: @game,
      user: current_user,
      home_score: params[:home_score],
      away_score: params[:away_score],
      force: params[:force] == 'true',
      resolve: params[:resolve] == 'true'
    )
    update.perform

    if update.succeeded?
      head :ok
    else
      render json: { error: update.message }, status: :unprocessable_entity
    end
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
