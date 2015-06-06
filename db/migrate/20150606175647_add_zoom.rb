class AddZoom < ActiveRecord::Migration
  def self.up
    add_column :tournaments, :lat,  :decimal, :precision => 15, :scale => 10, :default => 56
    add_column :tournaments, :long, :decimal, :precision => 15, :scale => 10, :default => -96
    add_column :tournaments, :zoom, :integer, :default => 4
    remove_column :tournaments, :gen_loc
  end

  def self.down
    remove_column :tournaments, :lat
    remove_column :tournaments, :long
    remove_column :tournaments, :zoom
    add_column :tournaments, :gen_loc, :string
  end
end
