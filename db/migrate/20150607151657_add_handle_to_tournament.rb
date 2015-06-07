class AddHandleToTournament < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :handle, :string
  end

  def self.down
    add_column :tournaments, :handle
  end
end
