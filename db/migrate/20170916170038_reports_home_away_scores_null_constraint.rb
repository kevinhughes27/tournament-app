class ReportsHomeAwayScoresNullConstraint < ActiveRecord::Migration[5.0]
  def change
    # oops I forgot about the default scope in my backfill.
    ScoreReport.only_deleted.find_each do |report|
      home_score = if report.team == report.game.home
        report.team_score
      else
        report.opponent_score
      end

      away_score = if report.team == report.game.home
        report.opponent_score
      else
        report.team_score
      end

      report.update_columns(
        home_score: home_score,
        away_score: away_score
      )
    end

    change_column :score_reports, :home_score, :integer, null: false
    change_column :score_reports, :away_score, :integer, null: false
  end
end
