class Types::Division < Types::BaseObject
  graphql_name "Division"
  description "A Division"

  field :id, ID, null: true
  field :name, String, null: true
  field :numTeams, Int, null: true
  field :numDays, Int, null: true
  field :bracketType, String, null: true
  field :teamsCount, Int, null: true
  field :isSeeded, Boolean, null: true
  field :needsSeed, Boolean, null: true

  def teams_count
    object.teams.count
  end

  def is_seeded
    object.seeded?
  end

  def needs_seed
    object.dirty_seed?
  end
end
