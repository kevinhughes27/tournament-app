class Admin::ScheduleController < AdminController
  before_action :load_index_data, only: [:index]

  def index
    respond_to do |format|
      format.html
      format.pdf do
        load_divisions
        render pdf: 'schedule', orientation: 'Landscape'
      end
    end
  end

  def update
    ActiveRecord::Base.transaction do
      # reset field and start times first so swapping can work.
      # Otherwise it might trigger conflict validations.
      game_ids = games_params.map{ |p| p[:id].to_i }
      games = Game.where(tournament_id: @tournament.id, id: game_ids)
      games.update_all(field_id: nil, start_time: nil)

      games_params.each do |p|
        game = Game.find_by(tournament_id: @tournament.id, id: p[:id])
        game.update_attributes!(p)
      end
    end

    load_index_data
    render :index
  rescue ActiveRecord::RecordInvalid => error
    render json: {game_id: error.record.id, error: error.message}, status: :unprocessable_entity
  end

  private

  def load_index_data
    @games = @tournament.games.includes(:division)
    @fields = @tournament.fields.sort_by{ |f| f.name.gsub(/\D/, '').to_i }
    @times = time_slots
  end

  def load_divisions
    @divisions = @tournament.divisions.includes(:teams, games: [:home, :away])
  end

  def time_slots
    times = @games.pluck(:start_time).uniq

    if times.size > 1
      times = times.compact
      times.sort!
    end

    times = [Time.now] if times.first.blank?
    times
  end

  def games_params
    @games_params ||= params.permit(games: [
      :id,
      :field_id,
      :start_time
    ])
    @games_params[:games] ||= {}
    @games_params[:games].values
  end
end
