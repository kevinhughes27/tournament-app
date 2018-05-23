class Mutations::UpdateScore < Mutations::BaseMutation
  graphql_name "UpdateScore"

  argument :input, Types::UpdateScoreInput, required: true

  field :success, Boolean, null: false
  field :userErrors, [String], null: true
end
