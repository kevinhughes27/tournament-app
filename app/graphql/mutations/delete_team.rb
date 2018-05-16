module Mutations
  DeleteTeam = GraphQL::Relay::Mutation.define do
    name "DeleteTeam"

    input_field :team_id, types.ID
    input_field :confirm, types.Boolean

    return_field :success, !types.Boolean
    return_field :confirm, types.Boolean
    return_field :not_allowed, types.Boolean
    return_field :userErrors, types[types.String]

    resolve(Auth.protect(Resolvers::DeleteTeam))
  end
end
