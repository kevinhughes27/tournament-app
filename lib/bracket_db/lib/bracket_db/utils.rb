require 'erb'
require 'tilt'

module BracketDb
  def load(name)
    Tilt::ERBTemplate.new("#{BracketDb::brackets_path}/#{name}.json").render
  end
  module_function :load

  def partial(name, args = nil)
    Tilt::ERBTemplate.new("#{BracketDb::brackets_path}/partials/#{name}.json").render(Object.new, args)
  end
  module_function :partial

  def table_partial(name, args = nil)
    table = Tilt::ERBTemplate.new(
      "#{BracketDb::brackets_path}/partials/#{name}.json"
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
  module_function :table_partial
end
