class Bracket < FrozenRecord::Base
  self.base_path = 'db'

  class << self
    def types
      @types ||= Bracket.all.pluck(:name)
    end

    def types_with_num
      @types_with_num ||= Bracket.all.pluck(:name, :num_teams)
    end
  end

  def template
    @attributes['template'].with_indifferent_access
  end

  # aren't these really bracket_uids?

  def game_uids_for_round(round)
    template[:games].map{ |g| g[:uid] if g[:round] == round }.compact
  end

  def game_uids_past_round(round)
    template[:games].map{ |g| g[:uid] if g[:round] > round }.compact
  end

  def game_uids_for_seeding(seed_round)
    template[:games].map{ |g| g[:uid] if g[:seed] == seed_round }.compact
  end

  def game_uids_not_for_seeding(seed_round)
    template[:games].map{ |g| g[:uid] if g[:seed] != seed_round }.compact
  end

  def game_uid_for_place(place)
    template[:games].detect{ |g| g[:place] == place }[:uid]
  end
end
