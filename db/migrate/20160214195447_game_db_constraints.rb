class GameDbConstraints < ActiveRecord::Migration
  def change
    change_column :games, :tournament_id, :integer, null: false
    change_column :games, :division_id, :integer, null: false
  end
end
