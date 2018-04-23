module Mutations
  DivisionSeed = GraphQL::Relay::Mutation.define do
    name "DivisionSeed"

    input_field :division_id, types.ID
    input_field :team_ids, types[types.ID]
    input_field :seeds, types[types.Int]
    input_field :confirm, types.Boolean

    return_field :success, !types.Boolean
    return_field :confirm, types.Boolean
    return_field :errors, types[types.String]

    resolve(Auth.protect(Resolvers::DivisionSeed))
  end
end
