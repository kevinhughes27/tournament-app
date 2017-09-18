class ReportsHomeAwayScoresNullConstraint < ActiveRecord::Migration[5.0]
  def change
    # oops I forgot about the default scope in my backfill.
      # they can't be backfilled because the game is deleted in most cases.
      # this limits the use of soft deleted score reports. I am deleting them for
      # real on Production now since I don't need them for anything (they have short term value)
    ScoreReport.only_deleted.delete_all!
    change_column :score_reports, :home_score, :integer, null: false
    change_column :score_reports, :away_score, :integer, null: false
  end
end
