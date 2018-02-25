class AddEndAtToGame < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :end_time, :datetime
  end
end
