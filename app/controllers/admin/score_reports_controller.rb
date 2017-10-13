class Admin::ScoreReportsController < AdminController
  def index
    @reports = @tournament.score_reports.includes(game: [:home, :away, :division])
    sum_reports_by_team
  end

  def destroy
    @tournament.score_reports.find(params[:id]).destroy
  end

  private

  def sum_reports_by_team
    @reports_by_team = []
    @reports.group_by{ |r| r.other_team }.each do |team, reports|
      division_name = reports.first.game.division.name
      total = reports.sum { |r| r.total }
      avg = (total / reports.size.to_f).round(1)
      @reports_by_team << {
        name: team.name, division: division_name, avg: avg, total: total
      }
    end
  end
end
