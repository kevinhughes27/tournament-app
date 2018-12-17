class Mutations::CreateSeed < Mutations::BaseMutation
  graphql_name "CreateSeed"

  argument :input, Inputs::CreateSeedInput, required: true

  field :division, Types::Division, null: false
  field :success, Boolean, null: false
  field :message, String, null: true
end
