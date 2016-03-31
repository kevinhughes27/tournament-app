class AddNumDays < ActiveRecord::Migration
  def change
    add_column :divisions, :num_days, :integer, default: 2, null: false
  end
end
