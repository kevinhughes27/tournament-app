require_relative 'utils/visibility'

Schema = GraphQL::Schema.define do
  query QueryType
  mutation MutationType
end
