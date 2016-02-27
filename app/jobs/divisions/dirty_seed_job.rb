module Divisions
  class DirtySeedJob < ActiveJob::Base
    queue_as :default

    # returns true if seeding would result in changes
    # only for initial seed
    def perform(division:)
      return true if division.teams.blank?
      return true unless division.seeded?

      teams = division.teams.order(:seed)
      seeds = division.teams.pluck(:seed).sort

      seeds.each_with_index do |seed, idx|
        return true unless seed == (idx+1)
      end

      game_uids = division.bracket.game_uids_for_round(1)
      games = Game.where(division_id: division.id, bracket_uid: game_uids)

      return true unless games.all?{ |g| g.valid_for_seed_round? }

      seats = games.pluck(:home_prereq_uid, :away_prereq_uid).flatten.uniq
      seats.reject!{ |s| !s.to_s.is_i? }
      num_seats = seats.size

      return true unless num_seats == teams.size

      games.each do |game|
        if game.home_prereq_uid.is_i?
          return true if game.home != teams[game.home_prereq_uid.to_i - 1]
        end

        if game.away_prereq_uid.is_i?
          return true if game.away != teams[game.away_prereq_uid.to_i - 1]
        end
      end

      return false
    end
  end
end
