def load_bracket(name)
  Tilt::ERBTemplate.new("db/brackets/#{name}.json").render
end

def bracket_partial(name, args = nil)
  Tilt::ERBTemplate.new("db/brackets/partials/#{name}.json").render(Object.new, args)
end
