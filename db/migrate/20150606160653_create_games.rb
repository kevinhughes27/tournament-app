class CreateGames < ActiveRecord::Migration
  def change
    create_table :games do |t|
      t.integer :home_score
      t.integer :away_score
      t.datetime :start
      t.datetime :finished
      t.boolean :score_confirmed
      t.belongs_to :field, index: true
      t.timestamps null: false
    end
  end
end
