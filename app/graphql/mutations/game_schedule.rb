module Mutations
  GameSchedule = GraphQL::Relay::Mutation.define do
    name "GameSchedule"

    input_field :game_id, types.ID
    input_field :field_id, types.ID
    input_field :start_time, DateTimeType
    input_field :end_time, DateTimeType

    return_field :success, !types.Boolean
    return_field :errors, types[types.String]
    return_field :game, GameType

    resolve(Auth.protect(Resolvers::GameSchedule))
  end
end
