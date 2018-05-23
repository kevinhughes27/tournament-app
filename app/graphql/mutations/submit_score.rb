class Mutations::SubmitScore < Mutations::BaseMutation
  graphql_name "SubmitScore"

  argument :input, Types::SubmitScoreInput, required: true

  field :success, Boolean, null: false

  def resolve(input)
    Resolvers::SubmitScore.call(input[:input], context)
  end
end
