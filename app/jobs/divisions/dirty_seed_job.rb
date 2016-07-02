module Divisions
  class DirtySeedJob < ApplicationJob
    attr_reader :division

    # returns true if seeding would result in changes
    def perform(division:)
      @division = division

      return true unless division.seeded?
      return true if division.teams.blank?

      seeds.each_with_index do |seed, idx|
        return true unless seed == (idx+1)
      end

      return true unless games.all?{ |g| g.valid_for_seed_round? }

      num_seats = seats.size
      return true unless num_seats == teams.size

      games.each do |game|
        if game.home_prereq_uid.is_i?
          return true if game.home_id != seed_index_for_prereq(game.home_prereq_uid)
        end

        if game.away_prereq_uid.is_i?
          return true if game.away_id != seed_index_for_prereq(game.away_prereq_uid)
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
      @seats ||= games.pluck(:home_prereq_uid, :away_prereq_uid)
        .flatten
        .uniq
        .reject{ |s| !s.to_s.is_i? }
    end

    def games
      @games ||= if division.bracket.pool
        Game.where(
          tournament_id: division.tournament_id,
          division_id: division.id
        ).where.not(pool: nil)
      else
        game_uids = division.bracket.game_uids_for_seeding(1)
        Game.where(
          tournament_id: division.tournament_id,
          division_id: division.id,
          bracket_uid: game_uids
        )
      end
    end
  end
end
