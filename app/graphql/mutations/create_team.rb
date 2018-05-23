module Mutations
  CreateTeam = GraphQL::Relay::Mutation.define do
    name "CreateTeam"

    input_field :name, types.String
    input_field :email, types.String
    input_field :phone, types.String
    input_field :division_id, types.ID
    input_field :seed, types.Int

    return_field :success, !types.Boolean
    return_field :userErrors, types[types.String]
    return_field :team, Types::Team

    resolve(Auth.protect(Resolvers::CreateTeam))
  end
end
