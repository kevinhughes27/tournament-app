require 'json-schema'

class BracketDb::StructureValidator
  BRACKET_SCHEMA = {
    "type" => "object",
    "properties" => {
      "games" => { "type" => "array" },
      "places" => { "type" => "array" }
    },
    "required" => [
      "games",
      "places"
    ],
    "additionalProperties" => false
  }

  POOL_GAME_SCHEMA = {
    "properties" => {
      "pool" => { "type" => "string" },
      "round" => { "type" => "integer" },
      "home_pool_seed" => { "type" => ["string", "integer"] },
      "away_pool_seed" => { "type" => ["string", "integer"] },
      "home_prereq" => { "type" => ["string", "integer"] },
      "away_prereq" => { "type" => ["string", "integer"] },
    },
    "required" => [
      "pool",
      "home_prereq",
      "away_prereq"
    ],
    "additionalProperties" => false,
  }

  BRACKET_GAME_SCHEMA = {
    "properties" => {
      "seed_round"  => { "type" => "integer" },
      "round" => { "type" => "integer" },
      "bracket_uid"   => { "type" => ["string", "integer"] },
      "home_prereq"  => { "type" => ["string", "integer"] },
      "away_prereq"  => { "type" => ["string", "integer"] },
    },
    "required" => [
      "round",
      "bracket_uid",
      "home_prereq",
      "away_prereq"
    ],
    "additionalProperties" => false,
  }

  GAME_SCHEMA = {
    "type" => "object",
    "oneOf": [POOL_GAME_SCHEMA, BRACKET_GAME_SCHEMA]
  }

  PLACE_SCHEMA = {
    "properties" => {
      "position" => { "type" => "integer" },
      "prereq"  => { "type" => ["string", "integer"] },
    },
    "required" => [
      "position",
      "prereq"
    ],
    "additionalProperties" => false,
  }

  class ProgressionError < StandardError; end
  class NotEnoughPlaces < StandardError; end
  class TooMannyPlaces < StandardError; end
  class MissingPlaceError < StandardError; end
  class GamesPlacesMismatch < StandardError; end

  class << self
    def validate_schema(template_json)
      JSON::Validator.validate!(BRACKET_SCHEMA, template_json)
      JSON::Validator.validate!(GAME_SCHEMA, template_json[:games], list: true)
      JSON::Validator.validate!(PLACE_SCHEMA, template_json[:places], list: true)
    end

    # validates the presence of all seats (1 to N) in the seed round
    def validate_non_pool_seeding(template_json)
      games = template_json[:games].select{ |g| g[:pool].nil? && g[:seed] == 1 }
      seats = seats_for_games(games)
      seats.sort.each_with_index do |seat, idx|
        return false unless seat == (idx+1)
      end
    end

    def validate_pool_seeding(template_json)
      games = template_json[:games].select{ |g| g[:pool] && g[:seed] == 1 }
      seats = seats_for_games(games)
      seats.uniq.sort.each_with_index do |seat, idx|
        return false unless seat == (idx+1)
      end
    end

    # validates that the dependent games exist at least
    # aka if I say a game has 'wq1' in the top then 'q1'
    # needs to exist
    def validate_progression(template_json)
      uids = template_json[:games].map{ |g| g[:bracket_uid] }.compact

      games = template_json[:games].select do |g|
        g[:seed_round].nil? && g[:pool].nil?
      end

      homes = games.map{ |g| g[:home_prereq].gsub(/(W|L)/, '') }.uniq
      aways = games.map{ |g| g[:away_prereq].gsub(/(W|L)/, '') }.uniq

      reseed_uids = pool_reseed_uids(template_json)

      unused_uids = homes - uids - reseed_uids
      raise ProgressionError.new(unused_uids.join(',')) unless unused_uids == []

      unused_uids = aways - uids - reseed_uids
      raise ProgressionError.new(unused_uids.join(',')) unless unused_uids == []

      true
    end

    def validate_places(template_json)
      positions = template_json[:places].map { |p| p[:position] }
      raise TooMannyPlaces if positions.size > num_teams(template_json)
      raise NotEnoughPlaces unless num_teams(template_json) == positions.size
      positions.each_with_index do |p, idx|
        raise MissingPlaceError unless (idx+1) == p
      end
    end

    # verifies that the game which have a place (which is used for visualization only)
    # matches the places array. aka if a game has the field place => 1st then the winner
    # of that game better be the prereq of 1st place or else they don't match
    def validate_nodes_match_places(template_json)
      place_games = template_json[:games].map{ |g| g if g[:bracket_uid].try(:is_i?) }.compact
      place_games.each do |game|
        place_num = game[:bracket_uid].to_i
        place_obj = template_json[:places].detect{ |p| p[:position] == place_num }
        raise GamesPlacesMismatch unless place_obj[:prereq] == "W#{game[:bracket_uid]}"
      end
    end

    private

    def seats_for_games(games)
      seats = games.inject([]) do |seats, game|
        if is_integer?(game[:home_prereq].to_s)
          seats << game[:home_prereq].to_i
        end
        if is_integer?(game[:away_prereq].to_s)
          seats << game[:away_prereq].to_i
        end
        seats
      end
      seats
    end

    def pool_reseed_uids(template_json)
      uids = []
      pools = template_json[:games].map{ |g| g[:pool] }.compact.uniq
      pools.each do |pool|
         uids += reseed_uids_for_pool(template_json, pool)
      end
      uids
    end

    def reseed_uids_for_pool(template_json, pool_name)
      (1..num_teams_for_pool(template_json, pool_name)).map do |num|
        "#{pool_name}#{num}"
      end
    end

    def num_teams(template_json)
      games = template_json[:games].select{ |g| g[:pool] || g[:seed_round] == 1 }

      teams = Set.new
      games.each do |game|
        if is_integer?(game[:home_prereq].to_s)
          teams << game[:home_prereq]
        end

        if is_integer?(game[:away_prereq].to_s)
          teams << game[:away_prereq]
        end
      end

      teams.size
    end

    def num_teams_for_pool(template_json, pool_name)
      teams = Set.new
      template_json[:games].each do |game|
        next unless game[:pool] == pool_name
        teams << game[:home_prereq]
        teams << game[:away_prereq]
      end

      teams.size
    end

    def is_integer?(string)
      /\A[-+]?\d+\z/ === string
    end
  end
end
