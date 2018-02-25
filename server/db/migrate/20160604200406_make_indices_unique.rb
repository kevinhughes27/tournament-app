class MakeIndicesUnique < ActiveRecord::Migration[5.0]
  def change
    remove_index :divisions, [:tournament_id, :name]
    add_index :divisions, [:tournament_id, :name], unique: true

    add_index :fields, [:tournament_id, :name], unique: true

    add_index :teams, [:tournament_id, :name], unique: true

    add_index :tournaments, :name, unique: true
    add_index :tournaments, :handle, unique: true

    remove_index :tournament_users, [:user_id, :tournament_id]
    add_index :tournament_users, [:user_id, :tournament_id], unique: true

    remove_index :maps, :tournament_id
    add_index :maps, :tournament_id, unique: true

    add_index :score_report_confirm_tokens, :score_report_id, unique: true
  end
end
