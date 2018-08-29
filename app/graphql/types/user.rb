class Types::User < Types::BaseObject
  graphql_name "User"
  description "A User"

  field :id, ID, null: false
  field :name, String, null: true
  field :email, String, null: false
  
end
