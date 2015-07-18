class AddScoreReports < ActiveRecord::Migration
  def change
    create_table :score_reports do |t|
      t.integer :tournament_id
      t.integer :game_id
      t.integer :team_id
      t.string  :submitter_fingerprint
      t.integer :rules_knowledge, limit: 1
      t.integer :fouls, limit: 1
      t.integer :fairness, limit: 1
      t.integer :attitude, limit: 1
      t.integer :communication, limit: 1
      t.timestamps null: false
    end
  end
end
