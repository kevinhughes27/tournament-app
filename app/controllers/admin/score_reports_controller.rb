class Admin::ScoreReportsController < AdminController

  def index
    @score_reports = @tournament.score_reports.includes(game: [:home, :away])
  end

end
