module Mutations
  DeleteDivision = GraphQL::Relay::Mutation.define do
    name "DeleteDivision"

    input_field :division_id, types.ID
    input_field :confirm, types.Boolean

    return_field :success, !types.Boolean
    return_field :confirm, types.Boolean
    return_field :userErrors, types[types.String]

    resolve(Auth.protect(Resolvers::DeleteDivision))
  end
end
