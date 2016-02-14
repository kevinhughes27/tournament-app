class AddRoundToGame < ActiveRecord::Migration
  def change
    add_column :games, :round, :integer
  end
end
