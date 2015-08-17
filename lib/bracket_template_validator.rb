class BracketTemplateValidator

  GAME_SCHEMA = {
    "type" => "object",
    "required" => [
       "round",
         "uid",
         "top",
      "bottom"
    ],
    "additionalProperties" => false,
    "properties" => {
       "round" => { "type" => "integer" },
         "uid" => { "type" => ["string", "integer"] },
         "top" => { "type" => ["string", "integer"] },
      "bottom" => { "type" => ["string", "integer"] },
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
      validate_num_teams(template_json) &&
      validate_first_round(template_json) &&
      validate_progression(template_json)
    end

    def validate_schema(template_json)
      JSON::Validator.validate!(BRACKET_SCHEMA, template_json, strict: true)
    end

    # validates that the number of teams is twice the
    # number of games in round1
    def validate_num_teams(template_json)
      num_teams = template_json[:num_teams]
      round1_games = template_json[:games].select{ |g| g[:round] == 1 }

      num_teams / 2 == round1_games.size
    end

    # validates the seats in round1 are a set from 1 to N
    def validate_first_round(template_json)
      games = template_json[:games].select{ |g| g[:round] == 1 }

      seats = games.inject([]) do |seats, game|
        seats << game[:top].to_i
        seats << game[:bottom].to_i
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

      non_seed_games = template_json[:games].select{ |g| g[:round] != 1 }
      tops = non_seed_games.map{ |g| g[:top].gsub(/(w|l)/, '') }.uniq
      bottoms = non_seed_games.map{ |g| g[:bottom].gsub(/(w|l)/, '') }.uniq

      tops - uids == [] &&
      bottoms - uids == []
    end

  end
end
