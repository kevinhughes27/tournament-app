module Mutations
  DivisionDelete = GraphQL::Relay::Mutation.define do
    name "DivisionDelete"

    input_field :division_id, types.ID
    input_field :confirm, types.Boolean

    return_field :success, !types.Boolean
    return_field :confirm, types.Boolean
    return_field :errors, types[types.String]

    resolve(Auth.protect(Resolvers::DivisionDelete))
  end
end