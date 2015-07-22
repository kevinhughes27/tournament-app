class AddSeedToTeam < ActiveRecord::Migration
  def change
    add_column :teams, :seed, :string
  end
end
