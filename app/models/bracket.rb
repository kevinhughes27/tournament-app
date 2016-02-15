class Bracket < FrozenRecord::Base
  self.base_path = 'db'

  class << self
    def types
      Bracket.all.pluck(:name)
    end

    def types_with_num
      Bracket.all.pluck(:name, :num_teams)
    end
  end

  def template
    @attributes['template'].with_indifferent_access
  end
end
