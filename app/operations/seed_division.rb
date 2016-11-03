class SeedDivision < ApplicationOperation
  property :division, accepts: Division, required: true
  property :team_ids, accepts: Array
  property :seeds, accepts: Array
  property :confirm, default: false

  SEED_ROUND = 1

  def execute
    halt 'confirm_seed' if !(confirm == 'true' || division.safe_to_seed?)
    update_teams
    halt 'Ambiguous seed list' if ambiguous_seeds?
    halt "#{num_seats} seats but #{num_teams} teams present" unless num_seats == num_teams
    seed
  end

  def confirmation_required?
    halted? && message == 'confirm_seed'
  end

  private

  def ambiguous_seeds?
    return unless seeds.present?

    seeds.sort.each_with_index do |seed, idx|
      return true unless seed.to_i == (idx+1)
    end
    return false
  end

  def update_teams
    return unless team_ids

    Team.transaction do
      team_ids.each_with_index do |team_id, idx|
        team = teams.detect { |t| t.id == team_id.to_i}
        next if team.seed == seeds[idx].to_i
        team.assign_attributes(seed: seeds[idx])
        team.save!
      end
    end
  end

  def seed
    Tournament.transaction do
      update_games
      reset_games
      update_division
    end
  end

  def update_games
    games.each do |game|
      game.home = seed_index_for_prereq(game.home_prereq)
      game.away = seed_index_for_prereq(game.away_prereq)
      game.reset_score!
      game.save!
    end
  end

  def reset_games
    games = Game.where(
      tournament_id: division.tournament_id,
      division_id: division.id,
    ).where.not(
      bracket_uid: nil,
      seed_round: SEED_ROUND
    )

    games.each do |game|
      game.home = nil
      game.away = nil
      game.home_score = nil
      game.away_score = nil
      game.save!
    end
  end

  def update_division
    division.update_attribute(:seeded, true)
  end

  def seed_index_for_prereq(prereq)
    return unless prereq.is_i?
    teams[prereq.to_i - 1]
  end

  def teams
    @teams ||= division.teams.order(:seed)
  end

  def num_teams
    teams.size
  end

  def seats
    @seats ||= games.pluck(:home_prereq, :away_prereq)
      .flatten
      .uniq
      .reject{ |s| !s.to_s.is_i? }
  end

  def num_seats
    seats.size
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
        seed_round: SEED_ROUND
      )
    end
  end
end
