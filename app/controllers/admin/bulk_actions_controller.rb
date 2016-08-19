class Admin::BulkActionsController < AdminController
  class MissingActionError < StandardError; end

  def perform
    action.perform
    render json: action.response, status: action.status
  end

  private

  def action
    action_class.new(**args)
  end

  def action_class
    "BulkActions::#{params[:action_class].classify}".safe_constantize or raise MissingActionError
  end

  def args
    {tournament_id: @tournament.id, ids: params[:ids], arg: params[:arg]}
  end
end
