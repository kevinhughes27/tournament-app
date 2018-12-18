class Mutations::DeleteSeed < Mutations::BaseMutation
  graphql_name "DeleteSeed"

  argument :input, Inputs::DeleteSeedInput, required: true

  field :division, Types::Division, null: false
  field :success, Boolean, null: false
  field :confirm, Boolean, null: true
  field :message, String, null: false
end
