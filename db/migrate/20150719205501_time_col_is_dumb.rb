class TimeColIsDumb < ActiveRecord::Migration
  def change
    remove_column :tournaments, :time_cap
    add_column :tournaments, :time_cap, :float
  end
end
