class Admin::BracketDbController < AdminController
  def index
    brackets = BracketDb.where(
      teams: params[:num_teams].to_i,
      days: params[:num_days].to_i
    )
    render json: brackets.to_json(methods: :bracket_tree)
  end

  def show
    bracket = BracketDb.find(handle: params[:handle])
    render json: bracket.to_json(methods: :bracket_tree)
  end
end
