class CleanupTeam < ActiveRecord::Migration[5.2]
  def change
    remove_column :teams, :division_id
    remove_column :teams, :seed
  end
end
