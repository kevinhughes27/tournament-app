class UpdateGameForDivisions < ActiveRecord::Migration
  def change
    rename_column :games, :bracket_id, :division_id
  end
end
