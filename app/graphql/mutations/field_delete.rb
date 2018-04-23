module Mutations
  FieldDelete = GraphQL::Relay::Mutation.define do
    name "FieldDelete"

    input_field :field_id, types.ID
    input_field :confirm, types.Boolean

    return_field :success, !types.Boolean
    return_field :confirm, types.Boolean
    return_field :errors, types[types.String]

    resolve(Auth.protect(Resolvers::FieldDelete))
  end
end
