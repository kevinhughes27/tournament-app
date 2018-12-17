class RenameRank < ActiveRecord::Migration[5.2]
  def change
    rename_column :seeds, :seed, :rank
  end
end
