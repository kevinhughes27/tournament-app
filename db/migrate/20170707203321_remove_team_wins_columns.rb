class RemoveTeamWinsColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :teams, :wins
    remove_column :teams, :points_for
  end
end
