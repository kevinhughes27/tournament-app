class Types::Team < Types::BaseObject
  graphql_name "Team"
  description "A Team"

  field :id, ID, null: false
  field :name, String, null: false
  field :email, String, auth: :required, null: true
  field :phone, String, auth: :required, null: true
  field :division, Types::Division, null: true
  field :seed, Int, null: true

  def seed
    object.seed && object.seed.rank
  end

  def division
    RecordLoader.for(Division).load(object.seed.division_id)
  end
end
