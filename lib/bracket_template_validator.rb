class BracketTemplateValidator
  GAME_SCHEMA = {
    "type" => "object",
    "required" => [
       "round",
         "uid",
         "home",
         "away"
    ],
    "additionalProperties" => false,
    "properties" => {
       "round" => { "type" => "integer" },
        "seed" => { "type" => "integer" },
         "uid" => { "type" => ["string", "integer"] },
        "home" => { "type" => ["string", "integer"] },
        "away" => { "type" => ["string", "integer"] },
    }
  }

  BRACKET_SCHEMA = {
    "type" => "object",
    "required" => ["num_teams", "games"],
    "additionalProperties" => false,
    "properties" => {
      "num_teams" => { "type" => "integer" },
      "games" => {
        "type" => "array",
        "items" => [GAME_SCHEMA]
      }
    }
  }

  class << self
    def validate(template_json)
      validate_schema(template_json) &&
      validate_seeding(template_json) &&
      validate_progression(template_json)
    end

    def validate_schema(template_json)
      JSON::Validator.validate!(BRACKET_SCHEMA, template_json, strict: true)
    end

    # validates the presence of all seats (1 to N) in the seed round
    def validate_seeding(template_json)
      games = template_json[:games].select{ |g| g[:seed] == 1 }

      seats = games.inject([]) do |seats, game|

        if game[:home].to_s.is_i?
          seats << game[:home].to_i
        end

        if game[:away].to_s.is_i?
          seats << game[:away].to_i
        end

        seats
      end

      seats.sort.each_with_index do |seat, idx|
        return false unless seat == (idx+1)
      end
    end

    # validates that the dependent games exist at least
    # aka if I say a game has 'wq1' in the top then 'q1'
    # needs to exist
    def validate_progression(template_json)
      uids = template_json[:games].map{ |g| g[:uid] }

      non_seed_games = template_json[:games].select{ |g| g[:seed] != 1 }
      homes = non_seed_games.map{ |g| g[:home].gsub(/(w|l)/, '') }.uniq
      aways = non_seed_games.map{ |g| g[:away].gsub(/(w|l)/, '') }.uniq

      homes - uids == [] &&
      aways - uids == []
    end
  end
end
