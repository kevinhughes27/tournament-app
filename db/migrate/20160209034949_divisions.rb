class Divisions < ActiveRecord::Migration
  def change
    rename_table(:brackets, :divisions)
  end
end
