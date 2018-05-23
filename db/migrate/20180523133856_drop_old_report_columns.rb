class DropOldReportColumns < ActiveRecord::Migration[5.0]
  def change
    remove_column :score_reports, :team_score
    remove_column :score_reports, :opponent_score
  end
end
