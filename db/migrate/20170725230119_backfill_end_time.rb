class BackfillEndTime < ActiveRecord::Migration[5.0]
  def change
    Game.all.find_each do |game|
      next unless game.scheduled?

      tournament = game.tournament
      end_time = game.start_time + tournament.time_cap.minutes
      game.update_columns(end_time: end_time)
    end
  end
end
