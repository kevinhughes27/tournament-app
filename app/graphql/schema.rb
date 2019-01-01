class Schema < GraphQL::Schema
  query Types::Query
  mutation Types::Mutation
  subscription Types::Subscription

  use BatchLoader::GraphQL
  use GraphQL::Subscriptions::ActionCableSubscriptions
end
