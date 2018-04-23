module Mutations
  GameSchedule = GraphQL::Relay::Mutation.define do
    name "GameSchedule"

    input_field :game_id, types.ID
    input_field :field_id, types.ID
    input_field :start_time, types.String
    input_field :end_time, types.String

    return_field :success, !types.Boolean
    return_field :errors, types[types.String]
    return_field :game, GameType

    resolve(Auth.protect(Resolvers::GameSchedule))
  end
end
