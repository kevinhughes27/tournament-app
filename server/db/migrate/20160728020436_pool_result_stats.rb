class PoolResultStats < ActiveRecord::Migration[5.0]
  def change
    add_column :pool_results, :wins, :integer
    add_column :pool_results, :points, :integer
  end
end
