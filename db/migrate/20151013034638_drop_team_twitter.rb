class DropTeamTwitter < ActiveRecord::Migration
  def change
    remove_column :teams, :twitter
  end
end
