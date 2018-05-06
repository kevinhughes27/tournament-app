module Mutations
  GameUpdateScore = GraphQL::Relay::Mutation.define do
    name "GameUpdateScore"

    input_field :game_id, types.ID
    input_field :home_score, types.Int
    input_field :away_score, types.Int
    input_field :force, types.Boolean
    input_field :resolve, types.Boolean

    return_field :success, !types.Boolean
    return_field :errors, types[types.String]

    resolve(Auth.protect(Resolvers::GameUpdateScore))
  end
end
