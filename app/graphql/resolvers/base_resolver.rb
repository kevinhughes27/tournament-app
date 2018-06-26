class Resolvers::BaseResolver
  def self.call(inputs, ctx)
    self.new.call(inputs, ctx)
  end

  def database_id(global_id)
    _, id = GraphQL::Schema::UniqueWithinType.decode(global_id)
    return id
  end
end
