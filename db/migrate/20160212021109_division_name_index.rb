class DivisionNameIndex < ActiveRecord::Migration
  def change
    add_index :divisions, :name
  end
end
