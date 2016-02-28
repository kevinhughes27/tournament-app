class BracketTemplateValidator
  BRACKET_SCHEMA = {
    "type" => "object",
    "properties" => {
      "num_teams" => { "type" => "integer" },
      "games"     => { "type" => "array" }
    },
    "required" => [
      "num_teams",
      "games"
    ],
    "additionalProperties" => false
  }

  POOL_GAME_SCHEMA = {
    "properties" => {
      "pool" => { "type" => ["string", "integer"] },
      "home"  => { "type" => ["string", "integer"] },
      "away"  => { "type" => ["string", "integer"] },
    },
    "required" => [
      "pool",
      "home",
      "away"
    ],
    "additionalProperties" => false,
  }

  BRACKET_GAME_SCHEMA = {
    "properties" => {
      "seed"  => { "type" => "integer" },
      "round" => { "type" => "integer" },
      "place" => { "type" => "integer" },
      "uid"   => { "type" => ["string", "integer"] },
      "home"  => { "type" => ["string", "integer"] },
      "away"  => { "type" => ["string", "integer"] },
    },
    "required" => [
      "round",
      "uid",
      "home",
      "away"
    ],
    "additionalProperties" => false,
  }

  GAME_SCHEMA = {
    "type" => "object",
    "oneOf": [POOL_GAME_SCHEMA, BRACKET_GAME_SCHEMA]
  }

  class << self
    def validate_schema(template_json)
      JSON::Validator.validate!(BRACKET_SCHEMA, template_json)
      JSON::Validator.validate!(GAME_SCHEMA, template_json[:games], list: true)
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

    def validate_pools(template_json)
      games = template_json[:games].select do |g|
        g[:seed].nil? && g[:pool].nil?
      end

      homes = games.map{ |g| g[:home] }
      aways = games.map{ |g| g[:away] }

      reseed_uids = pool_reseed_uids(template_json)
      reseed_uids - homes - aways == []
    end

    # validates that the dependent games exist at least
    # aka if I say a game has 'wq1' in the top then 'q1'
    # needs to exist
    def validate_progression(template_json)
      uids = template_json[:games].map{ |g| g[:uid] }.compact

      games = template_json[:games].select do |g|
        g[:seed].nil? && g[:pool].nil?
      end

      homes = games.map{ |g| g[:home].gsub(/(w|l)/, '') }.uniq
      aways = games.map{ |g| g[:away].gsub(/(w|l)/, '') }.uniq
      reseed_uids = pool_reseed_uids(template_json)

      homes - uids - reseed_uids == [] &&
      aways - uids - reseed_uids == []
    end

    private

    def seats_for_games(games)
      seats = games.inject([]) do |seats, game|
        if game[:home].to_s.is_i?
          seats << game[:home].to_i
        end
        if game[:away].to_s.is_i?
          seats << game[:away].to_i
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

    def num_teams_for_pool(template_json, pool_name)
      teams = Set.new
      template_json[:games].each do |game|
        next unless game[:pool] == pool_name
        teams << game[:home]
        teams << game[:away]
      end

      teams.size
    end
  end
end
