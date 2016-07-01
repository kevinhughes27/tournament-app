module Divisions
  class FinishPoolJob < ApplicationJob
    attr_reader :division, :pool

    def perform(division:, pool_uid:)
      @division = division
      @pool = Pool.new(division, pool_uid)

      return unless pool.finished?
      pool.clear_results
      pool.persist_results
      reseed
      push_places
    end

    private

    def reseed
      division.games.each do |game|

        if prereq_uid_from_pool?(game.home_prereq_uid)
          team = team_for_prereq(game.home_prereq_uid)
          game.home = team
        end

        if prereq_uid_from_pool?(game.away_prereq_uid)
          team = team_for_prereq(game.away_prereq_uid)
          game.away = team
        end

        next unless game.changed?

        if game.confirmed?
          game.reset!
          Divisions::ResetBracketJob.perform_later(game_id: game.id)
        end

        game.save!
      end
    end

    def push_places
      division.places.each do |place|
        if prereq_uid_from_pool?(place.prereq_uid)
          place.team = team_for_prereq(place.prereq_uid)
          place.save!
        end
      end
    end

    def prereq_uid_from_pool?(prereq_uid)
      prereq_uid =~ /#{pool.uid}\d/
    end

    def team_for_prereq(prereq_uid)
      pool.results[ pool_place_index_from_prereq(prereq_uid) ]
    end

    def pool_place_index_from_prereq(prereq_uid)
      prereq_uid.gsub(pool.uid, '').to_i - 1
    end
  end
end
