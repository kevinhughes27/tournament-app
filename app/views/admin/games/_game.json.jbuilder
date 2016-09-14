json.extract! game,
  :id,
  :pool,
  :home_prereq,
  :home_name,
  :away_prereq,
  :away_name,
  :home_score,
  :away_score

json.division game.division.name

json.bracket game.bracket_game?

json.has_teams game.teams_present?
json.played game.played?
json.confirmed game.confirmed?

json.score_reports(game.score_reports) do |report|
  json.partial! 'admin/score_reports/score_report', report: report
end

json.has_dispute game.score_disputes.present?
