class TimeColIsDumb < ActiveRecord::Migration
  def self.up
    remove_column :tournaments, :time_cap
    add_column :tournaments, :time_cap, :decimal, precision: 3
  end

  def self.down
  end
end
