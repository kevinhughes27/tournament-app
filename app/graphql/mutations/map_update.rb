module Mutations
  MapUpdate = GraphQL::Relay::Mutation.define do
    name "MapUpdate"

    input_field :lat, types.Float
    input_field :long, types.Float
    input_field :zoom, types.Int

    return_field :success, !types.Boolean

    resolve(Auth.protect(Resolvers::MapUpdate))
  end
end
