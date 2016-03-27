class AddDeleteAtToScoreReports < ActiveRecord::Migration
  def change
    add_column :score_reports, :deleted_at, :datetime
    remove_index :score_reports, [:tournament_id, :game_id]
    add_index :score_reports, [:tournament_id, :game_id, :deleted_at], name: 'tournament_game_deleted_at'
  end
end
