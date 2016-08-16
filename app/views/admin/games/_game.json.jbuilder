json.extract! game,
  :id,
  :pool,
  :name,
  :home_score,
  :away_score

json.division game.division.name

json.has_teams game.teams_present?
json.played game.played?
json.confirmed game.confirmed?
json.has_score_reports game.score_reports.present?
json.has_dispute game.score_disputes.present?

json.score_reports(game.score_reports) do |report|
  json.partial! 'admin/score_reports/score_report', report: report
end
