class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :maps, :tournament_id

    add_index :fields, :tournament_id

    add_index :divisions, :tournament_id
    remove_index :divisions, :name
    add_index :divisions, [:tournament_id, :name]

    add_index :teams, [:tournament_id, :division_id]

    add_index :score_reports, [:tournament_id, :game_id]

    remove_index :games, :field_id
    add_index :games, [:tournament_id, :division_id, :home_prereq_uid], name: 'tournament_division_home_prereq_uid'
    add_index :games, [:tournament_id, :division_id, :away_prereq_uid], name: 'tournament_division_away_prereq_uid'
    add_index :games, [:tournament_id, :division_id, :bracket_uid], name: 'tournament_division_bracket_uid'
    add_index :games, [:tournament_id, :division_id, :pool], name: 'tournament_division_pool'
    add_index :games, [:tournament_id, :division_id, :score_confirmed], name: 'tournament_division_confirmed'
    add_index :games, [:tournament_id, :field_id]
    add_index :games, [:tournament_id, :home_id]
    add_index :games, [:tournament_id, :away_id]
  end
end
