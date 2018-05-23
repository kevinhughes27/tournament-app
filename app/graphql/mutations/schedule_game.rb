module Mutations
  ScheduleGame = GraphQL::Relay::Mutation.define do
    name "ScheduleGame"

    input_field :game_id, types.ID
    input_field :field_id, types.ID
    input_field :start_time, Types::DateTime
    input_field :end_time, Types::DateTime

    return_field :success, !types.Boolean
    return_field :userErrors, types[types.String]
    return_field :game, Types::Game

    resolve(Auth.protect(Resolvers::ScheduleGame))
  end
end
