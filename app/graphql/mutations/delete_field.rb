module Mutations
  DeleteField = GraphQL::Relay::Mutation.define do
    name "DeleteField"

    input_field :field_id, types.ID
    input_field :confirm, types.Boolean

    return_field :success, !types.Boolean
    return_field :confirm, types.Boolean
    return_field :userErrors, types[types.String]

    resolve(Auth.protect(Resolvers::DeleteField))
  end
end
