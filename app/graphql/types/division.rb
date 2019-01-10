class Types::Division < Types::BaseObject
  graphql_name "Division"
  description "A Division"

  field :id, ID, null: false
  field :name, String, null: false
  field :numTeams, Int, null: false
  field :numDays, Int, null: false
  field :teamsCount, Int, null: false

  field :teams, [Types::Team], null: false
  field :bracket, Types::Bracket, null: false
  field :bracketTree, String, null: false
  field :games, [Types::Game], null: false

  field :isSeeded, Boolean, null: false
  field :needsSeed, Boolean, null: false

  def teams
    AssociationLoader.for(::Division, :teams).load(object).then do |teams|
      teams
    end
  end

  def teams_count
    object.teams.count
  end

  def games
    AssociationLoader.for(::Division, :games).load(object).then do |games|
      games
    end
  end

  def is_seeded
    object.seeded?
  end

  def needs_seed
    object.dirty_seed?
  end

  def bracket_tree
    BracketDb::to_tree(@object.games).to_json
  end
end
