class BackfillReportHomeAwayScores < ActiveRecord::Migration[5.0]
  def change
    ScoreReport.find_each do |report|
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
  end
end
