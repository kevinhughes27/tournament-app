class TimeColIsDumb < ActiveRecord::Migration
  def change
    change_column :tournaments, :time_cap, :float
  end
end
