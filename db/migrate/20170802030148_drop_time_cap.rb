class DropTimeCap < ActiveRecord::Migration[5.0]
  def change
    remove_column :tournaments, :time_cap
  end
end
