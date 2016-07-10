class BracketDb
  class << self
    def load(name)
      Tilt::ERBTemplate.new("db/brackets/#{name}.json").render
    end

    def partial(name, args = nil)
      Tilt::ERBTemplate.new("db/brackets/partials/#{name}.json").render(Object.new, args)
    end

    def table_partial(name, args = nil)
      table = Tilt::ERBTemplate.new(
        "db/brackets/partials/#{name}.json"
      ).render(Object.new, args)

      seeds = args[:seeds]
      games = JSON.parse("[#{table}]")

      games.each do |game|
        game['home'] = seeds[ game['home_seed'] - 1 ]
        game['away'] = seeds[ game['away_seed'] - 1 ]
      end

      games.to_json
        .gsub('[', '')
        .gsub(']', '')
    end
  end
end
