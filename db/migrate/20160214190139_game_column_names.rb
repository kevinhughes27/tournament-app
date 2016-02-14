class GameColumnNames < ActiveRecord::Migration
  def change
    rename_column :games, :bracket_top, :home_prereq_uid
    rename_column :games, :bracket_bottom, :away_prereq_uid
  end
end
