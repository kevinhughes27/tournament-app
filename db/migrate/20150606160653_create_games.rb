class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :home_id
      t.integer :away_id
      t.integer :home_score, default: 0
      t.integer :away_score, default: 0
      t.datetime :start
      t.datetime :finished
      t.boolean :score_confirmed
      t.belongs_to :field, index: true
      t.belongs_to :tournament, index: true
      t.timestamps null: false
    end
  end
end
