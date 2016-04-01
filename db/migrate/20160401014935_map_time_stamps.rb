class MapTimeStamps < ActiveRecord::Migration
  def change
    add_column :maps, :created_at, :datetime
    add_column :maps, :updated_at, :datetime
  end
end
