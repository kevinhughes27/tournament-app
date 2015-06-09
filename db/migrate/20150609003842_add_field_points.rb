class AddFieldPoints < ActiveRecord::Migration
  def self.up
    add_column :fields, :polygon, :string
  end

  def self.down
    remove_column :fields, :polygon, :string
  end
end
