require_relative 'loaders'

class Schema < GraphQL::Schema
  query Types::Query
  mutation Types::Mutation
  subscription Types::Subscription

  use GraphQL::Batch
  use GraphQL::Subscriptions::ActionCableSubscriptions
end

# This processes the schema members and makes some caches on the schema,
# maybe it's subject to a race condition?
# So eagerly warm that cache at load time:
Schema.graphql_definition
