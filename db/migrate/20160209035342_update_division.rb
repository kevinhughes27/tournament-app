class UpdateDivision < ActiveRecord::Migration
  def change
    rename_column :divisions, :division, :name
  end
end
