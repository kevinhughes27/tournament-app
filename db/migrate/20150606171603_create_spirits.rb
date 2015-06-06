class CreateSpirits < ActiveRecord::Migration
  def change
    create_table :spirits do |t|
      t.integer :author_id
      t.integer :subject_id
      t.integer :rule, limit: 1
      t.integer :foul, limit: 1
      t.integer :fair, limit: 1
      t.integer :tude, limit: 1
      t.integer :comm, limit: 1

      t.timestamps null: false
    end
  end
end
