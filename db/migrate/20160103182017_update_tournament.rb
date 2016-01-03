class UpdateTournament < ActiveRecord::Migration
  def change
    change_column :tournaments, :time_cap, :integer, default: 90, null: false
    remove_column :tournaments, :description
  end
end
