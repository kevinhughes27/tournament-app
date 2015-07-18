class Admin::ScoreReportsController < AdminController

  def index
    @score_reports = @tournament.score_reports
  end

end
