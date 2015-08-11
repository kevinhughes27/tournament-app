class Admin::ScheduleController < AdminController

  def index
    @games = @tournament.games.includes(:bracket)
    @fields = @tournament.fields.includes(:games).sort_by{|f| f.name.gsub(/\D/, '').to_i }
    @times = @games.pluck(:start_time).uniq
  end

  def update
    games_params.each do |p|
      game = Game.find(p[:id])
      game.update_attributes(p)
    end

    head :ok
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
