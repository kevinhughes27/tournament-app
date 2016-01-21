json.id game.id
json.division game.division
json.name game.name
json.has_teams game.teams_present?
json.home game.home_name
json.away game.away_name
json.home_score game.home_score
json.away_score game.away_score
json.played game.played?
json.confirmed game.confirmed?
json.score_reports(game.score_reports) do |report|
  json.partial! 'admin/games/score_report', report: report
end
