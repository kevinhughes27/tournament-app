class ReportsHomeAwayScoresNullConstraint < ActiveRecord::Migration[5.0]
  def change
    change_column :score_reports, :home_score, :integer, null: false
    change_column :score_reports, :away_score, :integer, null: false
  end
end
