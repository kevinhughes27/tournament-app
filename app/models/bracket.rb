require 'bracket_db/utils'

class Bracket < FrozenRecord::Base
  self.base_path = 'db'

  def template
    @attributes['template'].with_indifferent_access
  end

  def game_uids_for_round(round)
    template[:games].map{ |g| g[:uid] if g[:round] == round }.compact
  end

  def game_uids_for_seeding(seed_round)
    template[:games].map{ |g| g[:uid] if g[:seed] == seed_round }.compact
  end

  def game_uids_not_for_seeding(seed_round)
    template[:games].map{ |g| g[:uid] if g[:seed] != seed_round }.compact
  end
end
