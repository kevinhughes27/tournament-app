class Admin::ScheduleController < AdminController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  def index
    @teams = @tournament.teams
    @fields = @tournament.fields.includes(:games)
  end

  def create
    Game.update_set(@tournament.games, games_params)
    @teams = @tournament.teams
    @fields = @tournament.fields.includes(:games)
    render :index
  end

  private

  def games_params
    @games_params ||= params.permit(games: [
      :id,
      :field_id,
      :start_time,
      :home_id,
      :away_id
    ])
    @games_params[:games] ||= []
    @games_params[:games].each{ |t| t[1][:tournament_id] = @tournament.id }
  end
end
