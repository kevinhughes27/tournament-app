require_relative 'utils/definitions'

Schema = GraphQL::Schema.define do
  query QueryType
  mutation MutationType
end
