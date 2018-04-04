class GraphqlController < ApplicationController
  include TournamentConcern

  skip_before_action :verify_authenticity_token

  def create
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
    params[:filter] == false ? nil : OnlyFilter
  end
end
