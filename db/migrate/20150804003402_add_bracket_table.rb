class AddBracketTable < ActiveRecord::Migration
  def change
    create_table :brackets do |t|
      t.belongs_to :tournament
      t.string :bracket_type, null: false
      t.timestamps null: false
    end
  end
end
