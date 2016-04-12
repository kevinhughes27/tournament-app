class MapEdited < ActiveRecord::Migration
  def change
    add_column :maps, :edited_at, :datetime
  end
end
