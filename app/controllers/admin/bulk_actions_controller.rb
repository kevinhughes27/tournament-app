class Admin::BulkActionsController < AdminController
  class MissingActionError < StandardError; end

  def perform
    response = job.perform_now(**args)
    render json: response
  end

  private

  def job
    "BulkActions::#{params[:job].classify}Job".safe_constantize or raise MissingActionError
  end

  def args
    {ids: params[:ids], arg: params[:arg]}
  end
end
