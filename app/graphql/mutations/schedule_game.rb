class Mutations::ScheduleGame < Mutations::BaseMutation
  graphql_name "ScheduleGame"

  argument :input, Inputs::ScheduleGameInput, required: true

  field :success, Boolean, null: false
  field :userErrors, [String], null: true
  field :game, Types::Game, null: false
end
