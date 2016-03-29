class AddPlaces < ActiveRecord::Migration
  def change
    create_table :places do |t|
      t.integer :tournament_id, null: false
      t.integer :division_id, null: false
      t.integer :team_id
      t.integer :position, null: false
      t.string :prereq_uid, null: false
      t.timestamps
      t.index [:tournament_id, :division_id, :prereq_uid]
    end
  end
end
