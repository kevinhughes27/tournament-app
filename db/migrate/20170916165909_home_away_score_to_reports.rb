class HomeAwayScoreToReports < ActiveRecord::Migration[5.0]
  def change
    add_column :score_reports, :home_score, :integer
    add_column :score_reports, :away_score, :integer
  end
end
