json.extract! game,
  :id,
  :pool,
  :bracket_uid,
  :round,
  :home_pool_seed,
  :home_prereq,
  :home_name,
  :away_pool_seed,
  :away_prereq,
  :away_name,
  :home_score,
  :away_score,
  :field_id,
  :start_time,
  :end_time,
  :length,
  :updated_at

json.division game.division.name
json.division_id game.division.id

json.scheduled game.scheduled?
json.bracket game.bracket_game?

json.teams_present game.teams_present?
json.one_team_present game.one_team_present?

json.played game.played?
json.confirmed game.confirmed?
json.unconfirmed game.unconfirmed?

json.score_reports(game.score_reports) do |report|
  json.partial! 'admin/score_reports/score_report', report: report
end

json.has_dispute game.score_disputes.present?
