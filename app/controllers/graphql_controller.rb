class GraphqlController < ApiController
  include TournamentController

  def execute
    result = Schema.execute(
      query_string,
      variables: query_variables,
      context: {
        tournament: current_tournament,
        current_user: current_user
      },
      only: filter
    )

    render json: result
  end

  private

  def query_string
    params[:query]
  end

  def query_variables
    params[:variables]
  end

  def filter
    if Rails.env.production?
      Auth::Visibility::Filter
    else
      params[:filter] == false ? nil : Auth::Visibility::Filter
    end
  end
end
