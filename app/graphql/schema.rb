class Schema < GraphQL::Schema
  query Types::Query
  mutation Types::Mutation
  subscription Types::Subscription

  use GraphQL::Subscriptions::ActionCableSubscriptions

  def self.id_from_object(object, type_definition, query_ctx)
    GraphQL::Schema::UniqueWithinType.encode(object.class.name, object.id)
  end

  def self.object_from_id(id, query_ctx)
    class_name, item_id = GraphQL::Schema::UniqueWithinType.decode(id)
    Object.const_get(class_name).find(item_id)
  end
end
