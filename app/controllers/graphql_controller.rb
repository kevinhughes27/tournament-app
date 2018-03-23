class GraphqlController < ApplicationController
  include TournamentConcern

  skip_before_action :verify_authenticity_token

  def create
    query_string = params[:query]
    query_variables = params[:variables]

    result = Schema.execute(
      query_string,
      variables: query_variables,
      context: {
        tournament: @tournament,
        current_user: current_user
      },
      only: OnlyFilter
    )

    render json: result
  end
end
