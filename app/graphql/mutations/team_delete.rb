module Mutations
  TeamDelete = GraphQL::Relay::Mutation.define do
    name "TeamDelete"

    input_field :team_id, types.ID
    input_field :confirm, types.Boolean

    return_field :success, !types.Boolean
    return_field :confirm, types.Boolean
    return_field :not_allowed, types.Boolean
    return_field :errors, types[types.String]

    resolve(Auth.protect(Resolvers::TeamDelete))
  end
end
