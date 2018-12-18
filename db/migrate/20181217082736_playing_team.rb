class PlayingTeam < ActiveRecord::Migration[5.2]
  def change
    create_table :seeds do |t|
      t.integer :tournament_id, null: false
      t.integer :division_id, null: false
      t.integer :team_id, null: false
      t.integer :seed, null: false
      t.index :division_id
    end
  end
end
