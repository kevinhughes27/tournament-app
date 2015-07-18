class AddCommentsToScoreReports < ActiveRecord::Migration
  def change
    add_column :score_reports, :comments, :string
  end
end
