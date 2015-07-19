class AddGameTimeCap < ActiveRecord::Migration
  def change
    add_column :tournaments, :time_cap, :time
  end
end
