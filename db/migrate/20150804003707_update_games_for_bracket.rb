class UpdateGamesForBracket < ActiveRecord::Migration
  def change
    remove_column :games, :division
    add_column :games, :bracket_id, :integer
    rename_column :games, :bracket_code, :bracket_uid
  end
end
