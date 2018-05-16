module Mutations
  UpdateTeam = GraphQL::Relay::Mutation.define do
    name "UpdateTeam"

    input_field :team_id, types.ID
    input_field :name, types.String
    input_field :email, types.String
    input_field :phone, types.String
    input_field :division_id, types.ID
    input_field :seed, types.Int
    input_field :confirm, types.Boolean

    return_field :success, !types.Boolean
    return_field :confirm, types.Boolean
    return_field :not_allowed, types.Boolean
    return_field :errors, types[types.String]
    return_field :team, TeamType

    resolve(Auth.protect(Resolvers::UpdateTeam))
  end
end
