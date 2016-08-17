json.array!(reports) do |report|
  json.partial! 'admin/score_reports/score_report', report: report
end
