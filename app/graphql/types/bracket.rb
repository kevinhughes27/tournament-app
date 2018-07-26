class Types::Bracket < Types::BaseObject
  graphql_name "Bracket"
  description "Structure for games"

  field :handle, String, null: true
  field :name, String, null: true
  field :description, String, null: true
  field :numTeams, Int, null: true
  field :numDays, Int, null: true

  field :games, String, null: true
  field :places, String, null: true
  field :tree, String, null: true

  def num_teams
    object.teams
  end

  def num_days
    object.days
  end

  def games
    object.games.to_json
  end

  def places
    object.places.to_json
  end

  def tree
    object.tree.to_json
  end
end
