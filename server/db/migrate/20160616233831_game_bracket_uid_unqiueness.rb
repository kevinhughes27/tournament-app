class GameBracketUidUnqiueness < ActiveRecord::Migration[5.0]
  def change
    remove_index :games, [:tournament_id, :division_id, :bracket_uid]
    add_index :games, [:tournament_id, :division_id, :bracket_uid], unique: true
  end
end
