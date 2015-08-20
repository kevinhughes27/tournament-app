class Admin::ScoreReportsController < AdminController

  def index
    @games = @tournament.games.includes(:score_reports, :home, :away)
    render :index
  end

  def confirm
    report = ScoreReport.includes(:game).find(params[:id])
    game = report.game

    home_score = params[:home_score].to_i
    away_score = params[:away_score].to_i

    game.confirm_score(home_score, away_score)

    @score_reports = @tournament.score_reports.where(game_id: game.id)
    render :index, turbolinks: true, change: @score_reports.map{ |s| "score-reports:#{s.id}" }
  end

end
