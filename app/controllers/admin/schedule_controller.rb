class Admin::ScheduleController < AdminController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  def index
    @teams = @tournament.teams
    @fields = @tournament.fields.includes(:games)
    @games = [@tournament.games.build] if @games.blank?
  end

  def create
    @games = Game.update_set(@tournament.games, games_params)
    render :index
  end

  private

  def games_params
    @games_params ||= params.permit(teams: [
      :id,
      :field_id,
      :home,
      :away
    ])
    @games_params[:teams] ||= []
    @games_params[:teams].each{ |t| t[1][:tournament_id] = @tournament.id }
  end
end
