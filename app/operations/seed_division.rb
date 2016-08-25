class SeedDivision < ApplicationOperation
  processes :division, :confirm

  property :division, accepts: Division, required: true
  property :confirm, default: false

  property :seed_round, accepts: Integer, default: 1

  def execute
    halt 'confirm_seed' if !(confirm == 'true' || division.safe_to_seed?)

    seeds.each_with_index do |seed, idx|
      halt 'Ambiguous seed list' unless seed == (idx+1)
    end

    halt 'Invalid seed round' unless games.all?{ |g| g.valid_for_seed_round? }

    num_seats = seats.size
    halt "#{num_seats} seats but #{teams.size} teams present" unless num_seats == teams.size

    games.each do |game|
      game.home = seed_index_for_prereq(game.home_prereq)
      game.away = seed_index_for_prereq(game.away_prereq)
      game.reset_score!
      game.save!
    end

    reset_games(division: division, seed_round: seed_round)
    division.update_attribute(:seeded, true)
  end

  def confirmation_required?
    halted? && message == 'confirm_seed'
  end

  private

  def seed_index_for_prereq(prereq)
    return unless prereq.is_i?
    teams[prereq.to_i - 1]
  end

  def teams
    @teams ||= division.teams.order(:seed)
  end

  def seeds
    @seeds ||= teams.pluck(:seed).map(&:to_i).sort
  end

  def seats
    @seats ||= games.pluck(:home_prereq, :away_prereq)
      .flatten
      .uniq
      .reject{ |s| !s.to_s.is_i? }
  end

  def games
    @games ||= if division.bracket.pool
      Game.where(
        tournament_id: division.tournament_id,
        division_id: division.id
      ).where.not(
        pool: nil
      )
    else
      Game.where(
        tournament_id: division.tournament_id,
        division_id: division.id,
        seed_round: seed_round
      )
    end
  end

  def reset_games(division:, seed_round:)
    games = Game.where(
      tournament_id: division.tournament_id,
      division_id: division.id,
    ).where.not(
      bracket_uid: nil,
      seed_round: seed_round
    )

    games.each do |game|
      game.home = nil
      game.away = nil
      game.home_score = nil
      game.away_score = nil
      game.save!
    end
  end
end
