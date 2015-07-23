class BracketGameFields < ActiveRecord::Migration
  def change
    add_column :games, :division, :string
    add_column :games, :bracket_code, :string
    add_column :games, :bracket_top, :string
    add_column :games, :bracket_bottom, :string
  end
end
