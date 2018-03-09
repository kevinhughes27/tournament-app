class ScoreEntryModel < ActiveRecord::Migration[5.0]
  def change
    create_table :score_entries do |t|
      t.integer :tournament_id, null: false
      t.integer :user_id, null: false
      t.integer :game_id, null: false
      t.integer :home_id, null: false
      t.integer :away_id, null: false
      t.integer :home_score, null: false
      t.integer :away_score, null: false
      t.datetime :deleted_at
    end
  end
end
