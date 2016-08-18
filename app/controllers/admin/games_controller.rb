class Admin::GamesController < AdminController
  before_action :load_games, only: :index
  before_action :load_game, only: :update

  def index
  end

  def update
    update = UpdateGameScore.new(game: @game, **update_params)
    update.perform

    if update.succeeded?
      head :ok
    else
      head :unprocessable_entity
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

  def update_params
    update_params = params.permit(:home_score, :away_score)
    update_params[:force] = params[:force] == 'true'
    update_params[:resolve] = params[:resolve] == 'true'
    update_params[:user] = current_user
    update_params
  end
end
