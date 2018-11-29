class Types::User < Types::BaseObject
  graphql_name "User"
  description "A User"

  global_id_field :id

  field :name, String, null: true
  field :email, String, null: false
end
