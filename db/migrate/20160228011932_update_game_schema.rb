class UpdateGameSchema < ActiveRecord::Migration
  def change
    add_column :games, :pool, :string
  end
end
