class AddTournamentUsersJoin < ActiveRecord::Migration

  def change
    create_table :tournament_users do |t|
      t.integer :tournament_id
      t.integer :user_id
      t.timestamps null: false
    end

    add_index :tournament_users, :user_id
    add_index :tournament_users, :tournament_id
    add_index :tournament_users, [:user_id, :tournament_id]
  end

end
