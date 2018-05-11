module Mutations
  TeamCreate = GraphQL::Relay::Mutation.define do
    name "TeamCreate"

    input_field :name, types.String
    input_field :email, types.String
    input_field :phone, types.String
    input_field :division_id, types.ID
    input_field :seed, types.Int

    return_field :success, !types.Boolean
    return_field :errors, types[types.String]
    return_field :team, TeamType

    resolve(Auth.protect(Resolvers::TeamCreate))
  end
end
