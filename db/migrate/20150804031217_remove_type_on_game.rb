class RemoveTypeOnGame < ActiveRecord::Migration
  def change
    remove_column :games, :type
  end
end
