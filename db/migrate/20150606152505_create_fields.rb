class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :name
      t.decimal :lat, :precision => 15, :scale => 10, :default => 0.0
      t.decimal :long, :precision => 15, :scale => 10, :default => 0.0
      t.belongs_to :tournament, index: true
      t.timestamps null: false
    end
  end
end
