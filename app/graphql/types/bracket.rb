class Types::Bracket < Types::BaseObject
  graphql_name "Bracket"
  description "Structure for games"

  field :handle, String, null: false
  field :name, String, null: false
  field :description, String, null: false
  field :numTeams, Int, null: false
  field :numDays, Int, null: false

  field :games, String, null: false
  field :places, String, null: false
  field :tree, String, null: false

  def num_teams
    object.teams
  end

  def num_days
    object.days
  end

  def games
    object.games.map do |g|
      g.deep_transform_keys{ |k| k.to_s.camelize(:lower) }
    end.to_json
  end

  def places
    object.places.to_json
  end

  def tree
    object.tree.to_json
  end
end
