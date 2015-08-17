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

  def self.validate(template_json)
    JSON::Validator.validate!(BRACKET_SCHEMA, template_json, strict: true)
  end

end
