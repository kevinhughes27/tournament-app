class Types::BaseObject < GraphQL::Schema::Object
  field_class Auth::Field

  def database_id(global_id)
    _, id = GraphQL::Schema::UniqueWithinType.decode(global_id)
    return id
  end
end
