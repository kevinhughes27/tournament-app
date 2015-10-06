json.id game.id
json.division game.division
json.name game.name
json.home game.home_name
json.away game.away_name
json.score game.score
json.played game.played?
json.confirmed game.confirmed?
json.score_reports(game.score_reports) do |report|
  json.partial! 'admin/games/score_report', report: report
end
