class Mutations::UpdateScore < Mutations::BaseMutation
  graphql_name "UpdateScore"

  argument :input, Inputs::UpdateScoreInput, required: true

  field :game, Types::Game, null: false
  field :success, Boolean, null: false
  field :confirm, Boolean, null: true
  field :message, String, null: true
  field :userErrors, [Types::Error], null: true
end
