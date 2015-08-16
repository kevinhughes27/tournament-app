class Admin::ScoreReportsController < AdminController

  def index
    scope = if params[:game_id]
      @tournament.score_reports.where(game_id: params[:game_id])
    else
      @tournament.score_reports
    end

    @score_reports = scope.includes(game: [:home, :away]).order(:game_id)

    if params[:change]
      render :index, change: @score_reports.map{ |s| "score-report-#{s.id}"}
    else
      render :index
    end
  end

  def confirm
    report = ScoreReport.includes(:game).find(params[:id])
    game = report.game

    home_score = params[:home_score].to_i
    away_score = params[:away_score].to_i

    game.confirm_score(home_score, away_score)
    redirect_to admin_tournament_score_reports_path(@tournament, game_id: report.game_id, change: true)
  end

end
