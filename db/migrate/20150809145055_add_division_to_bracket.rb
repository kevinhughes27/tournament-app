class AddDivisionToBracket < ActiveRecord::Migration
  def change
    add_column :brackets, :division, :string
  end
end
