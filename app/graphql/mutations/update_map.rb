class Mutations::UpdateMap < Mutations::BaseMutation
  graphql_name "UpdateMap"

  argument :input, Types::UpdateMapInput, required: true

  field :success, Boolean, null: false
end
