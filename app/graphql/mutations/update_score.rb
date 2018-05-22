module Mutations
  UpdateScore = GraphQL::Relay::Mutation.define do
    name "UpdateScore"

    input_field :game_id, types.ID
    input_field :home_score, types.Int
    input_field :away_score, types.Int
    input_field :force, types.Boolean
    input_field :resolve, types.Boolean

    return_field :success, !types.Boolean
    return_field :userErrors, types[types.String]

    resolve(Auth.protect(Resolvers::UpdateScore))
  end
end
