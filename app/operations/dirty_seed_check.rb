class DirtySeedCheck < ApplicationOperation
  input :division, accepts: Division, required: true

  # returns true if seeding would result in changes
  def execute
    return true unless division.seeded?
    return true if division.teams.blank?

    seeds.each_with_index do |seed, idx|
      return true unless seed == (idx+1)
    end

    num_seats = seats.size
    return true unless num_seats == teams.size

    games.each do |game|
      if game.home_prereq.is_i?
        return true if game.home_id != seed_index_for_prereq(game.home_prereq)
      end

      if game.away_prereq.is_i?
        return true if game.away_id != seed_index_for_prereq(game.away_prereq)
      end
    end

    return false
  end

  private

  def seed_index_for_prereq(prereq)
    teams[prereq.to_i - 1].id
  end

  def teams
    @teams ||= division.teams.order(:seed)
  end

  def seeds
    @seeds ||= division.teams.pluck(:seed).map(&:to_i).sort
  end

  def seats
    @seats ||= games.pluck(:home_prereq, :away_prereq)
      .flatten
      .uniq
      .reject{ |s| !s.to_s.is_i? }
  end

  def games
    @games ||= if division.bracket.pools.present?
      Game.where(
        tournament_id: division.tournament_id,
        division_id: division.id
      ).where.not(pool: nil)
    else
      Game.where(
        tournament_id: division.tournament_id,
        division_id: division.id,
        seed_round: 1
      )
    end
  end
end
