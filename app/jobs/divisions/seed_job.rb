module Divisions
  class SeedJob < ActiveJob::Base
    queue_as :default

    attr_reader :division, :seed_round

    def perform(division:, seed_round:)
      @division, @seed_round = division, seed_round

      teams = division.teams.order(:seed)
      seeds = teams.pluck(:seed).sort

      seeds.each_with_index do |seed, idx|
        raise Division::AmbiguousSeedList, 'Ambiguous seed list' unless seed == (idx+1)
      end

      games = games_for_seed

      raise Division::InvalidSeedRound unless games.all?{ |g| g.valid_for_seed_round? }

      seats = games.pluck(:home_prereq_uid, :away_prereq_uid).flatten.uniq
      seats.reject!{ |s| !s.to_s.is_i? }
      num_seats = seats.size

      raise Division::InvalidNumberOfTeams, "#{num_seats} seats but #{teams.size} teams present" unless num_seats == teams.size

      games.each do |game|
        game.home = teams[ game.home_prereq_uid.to_i - 1 ] if game.home_prereq_uid.is_i?
        game.away = teams[ game.away_prereq_uid.to_i - 1 ] if game.away_prereq_uid.is_i?
        game.home_score = nil
        game.away_score = nil
        game.score_confirmed = false
        game.save!
      end

      reset_games(division: division, seed_round: seed_round)
    end

    private

    def games_for_seed
      if division.bracket.pool
        Game.where(division_id: division.id).where.not(pool: nil)
      else
        game_uids = division.bracket.game_uids_for_seeding(seed_round)
        Game.where(division_id: division.id, bracket_uid: game_uids)
      end
    end

    def reset_games(division:, seed_round:)
      game_uids = division.bracket.game_uids_not_for_seeding(seed_round)
      games = Game.where(division_id: division.id, bracket_uid: game_uids)

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
