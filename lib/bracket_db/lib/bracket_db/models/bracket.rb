require_relative '../utils'
require_relative '../to_tree'

class Bracket < FrozenRecord::Base
  self.base_path = BracketDb::db_path

  def template
    @attributes['template'].with_indifferent_access
  end

  def template_games
    template[:games]
  end

  def bracket_tree
    @bracket_tree ||= BracketDb::to_tree(template_games)
  end

  def game_uids_for_round(round)
    template_games.map{ |g| g[:uid] if g[:round] == round }.compact
  end

  def game_uids_for_seeding(seed_round)
    template_games.map{ |g| g[:uid] if g[:seed] == seed_round }.compact
  end

  def game_uids_not_for_seeding(seed_round)
    template_games.map{ |g| g[:uid] if g[:seed] != seed_round }.compact
  end
end
