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
      'Pool / Bracket',
      'Time',
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
    game = report.game

    [
      "#{game.home_name} vs #{game.away_name}",
      "#{game.pool || game.bracket_uid}",
      "#{report.game.playing_time_range_string}",
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
