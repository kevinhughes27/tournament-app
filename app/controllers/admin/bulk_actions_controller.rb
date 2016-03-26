class Admin::BulkActionsController < AdminController
  class MissingActionError < StandardError; end

  def perform
    response, status = job.perform_now(**args)
    render json: response, status: status
  end

  private

  def job
    "BulkActions::#{params[:job].classify}Job".safe_constantize or raise MissingActionError
  end

  def args
    {tournament_id: @tournament.id, ids: params[:ids], arg: params[:arg]}
  end
end
