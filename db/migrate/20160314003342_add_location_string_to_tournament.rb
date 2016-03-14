class AddLocationStringToTournament < ActiveRecord::Migration
  def change
    add_column :tournaments, :location, :string
  end
end
