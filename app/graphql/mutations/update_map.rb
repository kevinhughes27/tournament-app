module Mutations
  UpdateMap = GraphQL::Relay::Mutation.define do
    name "UpdateMap"

    input_field :lat, types.Float
    input_field :long, types.Float
    input_field :zoom, types.Int

    return_field :success, !types.Boolean

    resolve(Auth.protect(Resolvers::UpdateMap))
  end
end
