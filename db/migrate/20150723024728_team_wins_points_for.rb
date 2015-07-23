class TeamWinsPointsFor < ActiveRecord::Migration
  def change
    add_column :teams, :wins, :integer, default: 0
    add_column :teams, :points_for, :integer, default: 0
  end
end
