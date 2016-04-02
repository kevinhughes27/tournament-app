class AddSeededColumn < ActiveRecord::Migration
  def change
    add_column :divisions, :seeded, :boolean, default: false
  end
end
