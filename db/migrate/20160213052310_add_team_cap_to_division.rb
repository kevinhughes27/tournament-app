class AddTeamCapToDivision < ActiveRecord::Migration
  def change
    add_column :divisions, :num_teams, :integer, default: 8
  end
end
