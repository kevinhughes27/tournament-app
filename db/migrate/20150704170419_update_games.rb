class UpdateGames < ActiveRecord::Migration
  def change
    remove_column :games, :finished
    rename_column :games, :start, :start_time
  end
end
