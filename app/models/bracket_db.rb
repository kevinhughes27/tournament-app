class BracketDb
  PATH = Rails.root.join("db/brackets").freeze

  def self.[](type)
    load_template(type)
  end

  class << self
    def types
      @types ||= begin
        types = Dir.entries(PATH)
        types.reject!{ |f| f == "." || f == ".."}
        types.map{ |t| t.gsub('.json', '') }
      end
    end

    def templates
      @templates ||= types.inject(Hash.new) do |templates, type|
        templates[type]  = load_template(type)
        templates
      end
    end

    def templates_for(num_teams)
      templates.select{ |t| templates[t][:num_teams] == num_teams }
    end

    def load_template(type)
      path = File.join(PATH, "#{type}.json")
      file = File.read(path)
      JSON.parse(file).with_indifferent_access
    end
  end
end
