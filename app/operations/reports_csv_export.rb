require 'csv'

class ReportsCsvExport < ApplicationOperation
  input :reports, required: true, accepts: lambda { |reports| reports.all?{ |r| r.is_a?(ScoreReport) } }

  def execute
    csv = CSV.generate do |csv|
      csv << header
      reports.each do |report|
        csv << row(report)
      end
    end

    csv
  end

  def header
    [
      'Game',
      'Score',
      'Submitted By',
      'Team',
      'Rules Knowledge',
      'Fouls',
      'Fairness',
      'Attitude',
      'Communication',
      'Comments'
    ]
  end

  def row(report)
    [
      "#{report.game.home_name} vs #{report.game.away_name}",
      report.score,
      report.submitted_by,
      report.other_team.name,
      report.rules_knowledge,
      report.fouls,
      report.fairness,
      report.attitude,
      report.communication,
      report.comments
    ]
  end
end
