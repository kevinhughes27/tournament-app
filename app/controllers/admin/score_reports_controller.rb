class Admin::ScoreReportsController < AdminController
  def index
    @reports = @tournament.score_reports.includes(game: [:home, :away, :division])
    sum_reports_by_team
  end

  private

  def sum_reports_by_team
    @reports_by_team = []
    @reports.group_by{ |r| r.other_team }.each do |team, reports|
      division_name = reports.first.game.division.name
      total = reports.sum { |r| r.total }
      @reports_by_team << {
        name: team.name, division: division_name, total: total
      }
    end
  end
end
