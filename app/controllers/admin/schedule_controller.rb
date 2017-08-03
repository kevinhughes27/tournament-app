class Admin::ScheduleController < AdminController
  def index
    load_games
    load_fields
    respond_to do |format|
      format.html
      format.pdf do
        load_divisions
        render pdf: 'schedule', orientation: 'Landscape'
      end
    end
  end

  def update
    load_game

    ScheduleGame.perform(
      @game,
      params[:field_id],
      params[:start_time],
      params[:end_time]
    )

    render json: {
      game_id: @game.id,
      field_id: @game.field_id,
      start_time: @game.start_time,
      end_time: @game.end_time,
      updated_at: @game.updated_at
    }
  rescue => e
    render json: {
      game_id: @game.id,
      field_id: @game.field_id,
      start_time: @game.start_time,
      end_time: @game.end_time,
      updated_at: @game.updated_at,
      error: e.message
    }, status: :unprocessable_entity
  end

  def destroy
    game = Game.find_by(tournament_id: @tournament.id, id: params[:game_id])
    game.unschedule!
    head :ok
  end

  # def bulk_update
  #   ActiveRecord::Base.transaction do
  #     # reset field and start times first so swapping can work.
  #     # Otherwise it might trigger conflict validations.
  #     game_ids = games_params.map{ |p| p[:id].to_i }
  #     games = Game.where(tournament_id: @tournament.id, id: game_ids)
  #     games.update_all(field_id: nil, start_time: nil)
  #
  #     games_params.each do |p|
  #       @game = Game.find_by(tournament_id: @tournament.id, id: p[:id])
  #       if p[:field_id].present? && p[:start_time].present?
  #         ScheduleGame.perform(@game, p[:field_id], p[:start_time])
  #       end
  #     end
  #   end
  #
  #   load_index_data
  #   render :index
  #
  # rescue => e
  #   render json: {game_id: @game.id, error: e.message}, status: :unprocessable_entity
  # end

  private

  def load_game
    @game = Game.includes(
      :division,
      :home,
      :away,
      :score_reports,
      :score_disputes
    ).find_by(tournament_id: @tournament.id, id: params[:game_id])
  end

  def load_games
    @games = @tournament.games.includes(
      :division,
      :home,
      :away,
      :score_reports,
      :score_disputes
    ).order(division_id: :asc)
  end

  def load_fields
    @fields = @tournament.fields.sort_by{ |f| f.name.gsub(/\D/, '').to_i }
  end

  def load_divisions
    @divisions = @tournament.divisions.includes(:teams, games: [:home, :away])
  end
end
