class Admin::BulkOperationsController < AdminController
  def perform
    response = job.perform_now(**args)
    render json: response
  end

  private

  def job
    "BulkOperations::#{params[:job].classify}Job".safe_constantize
  end

  def args
    {ids: params[:ids], arg: params[:arg]}
  end
end
