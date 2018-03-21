class GraphqlController < ApplicationController
  include TournamentConcern

  skip_before_action :verify_authenticity_token

  def create
    query_string = params[:query]
    query_variables = params[:variables]
    context = { tournament: @tournament }

    result = Schema.execute(
      query_string,
      variables: query_variables,
      context: context
    )

    render json: result
  end
end
