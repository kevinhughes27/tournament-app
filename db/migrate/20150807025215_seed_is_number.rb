class SeedIsNumber < ActiveRecord::Migration
  def change
    remove_column :teams, :seed
    add_column :teams, :seed, :integer
  end
end
