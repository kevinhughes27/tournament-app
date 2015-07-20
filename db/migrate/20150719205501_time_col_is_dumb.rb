class TimeColIsDumb < ActiveRecord::Migration
  def change
    remove_column :tournaments, :time_cap
    add_column :tournaments, :time_cap, :decimal, precision: 3
  end
end
