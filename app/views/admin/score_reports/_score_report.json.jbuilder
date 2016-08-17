json.extract! report,
  :id,
  :game_id,
  :score,
  :home_score,
  :away_score,
  :submitted_by,
  :submitter_fingerprint,
  :sotg_score,
  :comments

json.submitted_at report.created_at.strftime("%A %l:%M %P")
json.sotg_warning report.sotg_warning?
