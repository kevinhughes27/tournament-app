class AddNullConstraint < ActiveRecord::Migration[5.0]
  def change
    change_column :pool_results, :wins, :integer, null: false
    change_column :pool_results, :points, :integer, null: false
  end
end
