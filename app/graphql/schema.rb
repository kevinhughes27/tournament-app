class Schema < GraphQL::Schema
  query Types::Query
  mutation Types::Mutation
  subscription Types::Subscription

  use GraphQL::Batch
  use GraphQL::Subscriptions::ActionCableSubscriptions
end
