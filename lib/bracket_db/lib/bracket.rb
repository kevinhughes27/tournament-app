require_relative 'utils'
require_relative 'to_tree'

class Bracket < FrozenRecord::Base
  self.base_path = BracketDb::db_path

  def template
    @attributes['template'].with_indifferent_access
  end

  def template_games
    template[:games]
  end

  def pools
    template_games.map{ |g| g[:pool] }.compact.uniq
  end

  def bracket_tree
    @bracket_tree ||= BracketDb::to_tree(template_games)
  end
end
