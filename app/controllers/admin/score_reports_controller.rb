class Admin::ScoreReportsController < AdminController

  def index
    @score_reports = @tournament.score_reports.includes(game: [:home, :away]).order(:game_id)
  end

end
