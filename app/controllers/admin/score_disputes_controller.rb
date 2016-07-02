class Admin::ScoreDisputesController < AdminController
  def resolve
    @game = Game.find(params[:game_id])
    @dispute = @game.score_disputes.find(params[:id])
    @dispute.user = current_user
    @dispute.resolve!
    head :ok
  end
end
