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
    BatchLoader.for(object.id).batch(default_value: []) do |division_ids, loader|
      Seed.includes(:team).where(division_id: division_ids).each do |seed|
        loader.call(seed.division_id) { |teams| teams << seed.team }
      end
    end
  end

  def teams_count
    object.teams.count
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
