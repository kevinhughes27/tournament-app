class Admin::GamesController < AdminController

  def confirm_score
    game = Game.find(params[:id])
    game.confirm_score(params[:home_score], params[:away_score])
    redirect_to admin_tournament_score_reports_path(@tournament)
  end

end
