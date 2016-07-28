class PoolResultStats < ActiveRecord::Migration[5.0]
  def change
    add_column :pool_results, :wins, :integer, null: false
    add_column :pool_results, :points, :integer, null: false
  end
end
