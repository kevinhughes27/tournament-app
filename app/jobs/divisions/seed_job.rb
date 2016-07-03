module Divisions
  class SeedJob < ApplicationJob
    attr_reader :division, :seed_round

    def perform(division:, seed_round:)
      @division, @seed_round = division, seed_round

      seeds.each_with_index do |seed, idx|
        raise Division::AmbiguousSeedList, 'Ambiguous seed list' unless seed == (idx+1)
      end

      raise Division::InvalidSeedRound unless games.all?{ |g| g.valid_for_seed_round? }

      num_seats = seats.size
      raise Division::InvalidNumberOfTeams, "#{num_seats} seats but #{teams.size} teams present" unless num_seats == teams.size

      games.each do |game|
        game.home = seed_index_for_prereq(game.home_prereq_uid)
        game.away = seed_index_for_prereq(game.away_prereq_uid)
        game.reset_score!
        game.save!
      end

      reset_games(division: division, seed_round: seed_round)
      division.update_attribute(:seeded, true)
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
      @seats ||= games.pluck(:home_prereq_uid, :away_prereq_uid)
        .flatten
        .uniq
        .reject{ |s| !s.to_s.is_i? }
    end

    def games
      @games ||= if division.bracket.pool
        Game.where(tournament_id: division.tournament_id, division_id: division.id).where.not(pool: nil)
      else
        game_uids = division.bracket.game_uids_for_seeding(seed_round)
        Game.where(tournament_id: division.tournament_id, division_id: division.id, bracket_uid: game_uids)
      end
    end

    def reset_games(division:, seed_round:)
      game_uids = division.bracket.game_uids_not_for_seeding(seed_round)
      games = Game.where(tournament_id: division.tournament_id, division_id: division.id, bracket_uid: game_uids)

      games.each do |game|
        game.home = nil
        game.away = nil
        game.home_score = nil
        game.away_score = nil
        game.score_confirmed = false
        game.save!
      end
    end
  end
end
