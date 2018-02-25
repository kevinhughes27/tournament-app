class StorePoolSeed < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :home_pool_seed, :string
    add_column :games, :away_pool_seed, :string
  end
end
