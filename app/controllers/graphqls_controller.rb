class GraphqlsController < ApplicationController
  include TournamentConcern

  def create
    query_string = params[:query]
    query_variables = JSON.load(params[:variables]) || {}
    context = { tournament: @tournament }

    result = Schema.execute(
      query_string,
      variables: query_variables,
      context: context
    )

    render json: result
  end
end
