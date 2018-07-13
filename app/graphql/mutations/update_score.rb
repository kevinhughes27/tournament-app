class Mutations::UpdateScore < Mutations::BaseMutation
  graphql_name "UpdateScore"

  argument :input, Inputs::UpdateScoreInput, required: true

  field :success, Boolean, null: false
  field :message, String, null: true
end
