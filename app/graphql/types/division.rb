class Types::Division < Types::BaseObject
  graphql_name "Division"
  description "A Division"

  field :id, ID, null: true
  field :name, String, null: true
  field :numTeams, Int, null: true
  field :numDays, Int, null: true
  field :bracketType, String, null: true
end
