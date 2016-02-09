class TeamDivisionForeignKey < ActiveRecord::Migration
  def change
    remove_column :teams, :division
    add_column :teams, :division_id, :integer
  end
end
