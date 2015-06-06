class CreateTeams < ActiveRecord::Migration
  def change
    create_table :teams do |t|
      t.string :name
      t.string :email
      t.string :sms
      t.string :twitter
      t.string :division
      t.belongs_to :tournament, index: true
      t.timestamps null: false
    end
  end
end
