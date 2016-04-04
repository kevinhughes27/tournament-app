class AddPoolResults < ActiveRecord::Migration
  def change
    create_table :pool_results do |t|
      t.integer :tournament_id, null: false
      t.integer :division_id, null: false
      t.integer :team_id, null: false
      t.string :pool, null: false
      t.integer :position, null: false
      t.timestamps
    end
  end
end
