class BracketDbDbConsistency < ActiveRecord::Migration[5.0]
  def change
    rename_column :games, :home_prereq_uid, :home_prereq
    rename_column :games, :away_prereq_uid, :away_prereq
    rename_column :places, :prereq_uid, :prereq
    add_column :games, :seed_round, :integer, default: 0
  end
end
