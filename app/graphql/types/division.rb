class Types::Division < Types::BaseObject
  graphql_name "Division"
  description "A Division"

  field :id, ID, null: false
  field :name, String, null: false
  field :numTeams, Int, null: false
  field :numDays, Int, null: false
  field :bracketType, String, null: false
end
