class Types::Team < Types::BaseObject
  graphql_name "Team"
  description "A Team"

  field :id, ID, null: true
  field :name, String, null: true
  field :email, String, auth_required: true, null: true
  field :phone, String, auth_required: true, null: true
  field :divisionId, Int, null: true
  field :seed, Int, null: true
end
