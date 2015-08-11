class Admin::ScheduleController < AdminController
  before_action :set_game, only: [:show, :edit, :update, :destroy]

  def index
    @games = @tournament.games.includes(:bracket)
    @fields = @tournament.fields.includes(:games).sort_by{|f| f.name.gsub(/\D/, '').to_i }
  end

  def create
    games_params.each do |p|
      game = Game.find(p[:id])
      game.update_attributes(p)
    end

    @games = @tournament.games.includes(:bracket)
    @fields = @tournament.fields.includes(:games).sort_by{|f| f.name.gsub(/\D/, '').to_i }
    render :index
  end

  private

  def games_params
    @games_params ||= params.permit(games: [
      :id,
      :field_id,
      :start_time
    ])
    @games_params[:games].values ||= []
  end
end
