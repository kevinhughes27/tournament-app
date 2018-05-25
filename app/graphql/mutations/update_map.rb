class Mutations::UpdateMap < Mutations::BaseMutation
  graphql_name "UpdateMap"

  argument :input, Inputs::UpdateMapInput, required: true

  field :success, Boolean, null: false
end
