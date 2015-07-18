class DropSpriritsEtc < ActiveRecord::Migration
  def change
    drop_table :spirits
    drop_table :spirits_teams
  end
end
