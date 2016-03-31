class RemoveNullConstraint < ActiveRecord::Migration
  def self.up
    change_column :places, :prereq_uid, :string, null: true
  end

  def self.down
    change_column :places, :prereq_uid, :string, null: false
  end
end
