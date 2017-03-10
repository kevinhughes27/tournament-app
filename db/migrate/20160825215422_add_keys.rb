class AddKeys < ActiveRecord::Migration
  def change
    add_foreign_key "divisions", "tournaments", name: "divisions_tournament_id_fk"

    add_foreign_key "fields", "tournaments", name: "fields_tournament_id_fk"

    add_foreign_key "games", "teams", column: "away_id", name: "games_away_id_fk"
    add_foreign_key "games", "divisions", name: "games_division_id_fk"
    add_foreign_key "games", "fields", name: "games_field_id_fk", on_update: :nullify, on_delete: :nullify
    add_foreign_key "games", "teams", column: "home_id", name: "games_home_id_fk"
    add_foreign_key "games", "tournaments", name: "games_tournament_id_fk"
    add_foreign_key "maps", "tournaments", name: "maps_tournament_id_fk"

    add_foreign_key "places", "divisions", name: "places_division_id_fk"
    add_foreign_key "places", "teams", name: "places_team_id_fk"
    add_foreign_key "places", "tournaments", name: "places_tournament_id_fk"

    add_foreign_key "pool_results", "divisions", name: "pool_results_division_id_fk"
    add_foreign_key "pool_results", "teams", name: "pool_results_team_id_fk"
    add_foreign_key "pool_results", "tournaments", name: "pool_results_tournament_id_fk"

    add_foreign_key "score_disputes", "games", name: "score_disputes_game_id_fk"
    add_foreign_key "score_disputes", "tournaments", name: "score_disputes_tournament_id_fk"
    add_foreign_key "score_disputes", "users", name: "score_disputes_user_id_fk"
    add_foreign_key "score_entries", "teams", column: "away_id", name: "score_entries_away_id_fk"
    add_foreign_key "score_entries", "games", name: "score_entries_game_id_fk"
    add_foreign_key "score_entries", "teams", column: "home_id", name: "score_entries_home_id_fk"
    add_foreign_key "score_entries", "tournaments", name: "score_entries_tournament_id_fk"
    add_foreign_key "score_entries", "users", name: "score_entries_user_id_fk"

    add_foreign_key "score_report_confirm_tokens", "score_reports", name: "score_report_confirm_tokens_score_report_id_fk"
    add_foreign_key "score_report_confirm_tokens", "tournaments", name: "score_report_confirm_tokens_tournament_id_fk"

    add_foreign_key "score_reports", "games", name: "score_reports_game_id_fk"
    add_foreign_key "score_reports", "teams", name: "score_reports_team_id_fk"
    add_foreign_key "score_reports", "tournaments", name: "score_reports_tournament_id_fk"

    add_foreign_key "teams", "divisions", name: "teams_division_id_fk", on_update: :nullify, on_delete: :nullify
    add_foreign_key "teams", "tournaments", name: "teams_tournament_id_fk"

    add_foreign_key "tournament_users", "tournaments", name: "tournament_users_tournament_id_fk"
    add_foreign_key "tournament_users", "users", name: "tournament_users_user_id_fk"

    add_foreign_key "user_authentications", "users", name: "user_authentications_user_id_fk"
  end
end
