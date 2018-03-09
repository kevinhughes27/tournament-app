class ScoreDisputeModel < ActiveRecord::Migration[5.0]
  def change
    create_table :score_disputes do |t|
      t.integer :tournament_id, null: false
      t.integer :user_id
      t.integer :game_id, null: false
      t.string :status, null: false
      t.datetime :deleted_at
      t.index [:tournament_id, :game_id, :deleted_at], name: 'score_dispute_tournament_game_deleted_at'
    end
  end
end
