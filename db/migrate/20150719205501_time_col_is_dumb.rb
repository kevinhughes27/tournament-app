class TimeColIsDumb < ActiveRecord::Migration
  def self.up
    remove_column :tournaments, :time_cap
    add_column :tournaments, :time_cap, :decimal, precision: 5, scale: 2
  end

  def self.down
    remove_column :tournaments, :time_cap
    add_column :tournaments, :time_cap, :time
  end
end
