class Admin::BracketDbController < AdminController
  def index
    brackets = BracketDb.options(teams: num_teams, days: num_days)
    json = brackets.map { |h, br| br.to_json }
    render json: json
  end

  def show
    bracket = BracketDb.find(handle: params[:handle])
    render json: bracket.to_json
  end

  private

  def num_days
    params[:num_days].to_i
  end

  def num_teams
    params[:num_teams].to_i
  end
end
