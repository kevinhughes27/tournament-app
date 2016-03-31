class AddPrereqLogic < ActiveRecord::Migration
  def change
    add_column :places, :prereq_logic, :string
  end
end
