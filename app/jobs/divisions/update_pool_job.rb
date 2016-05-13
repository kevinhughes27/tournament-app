module Divisions
  class UpdatePoolJob < ApplicationJob
    queue_as :default

    attr_reader :division, :pool

    def perform(division:, pool:)
      @division, @pool = division, pool
      record_results
      reseed
      push_places
    end

    private

    def record_results
      sorted_teams.each_with_index do |team, idx|
        position = idx + 1
        PoolResult.create!(
          tournament_id: division.tournament_id,
          division_id: division.id,
          pool: pool,
          position: position,
          team: team
        )
      end
    end

    def reseed
      division.games.each do |game|
        if game.home_prereq_uid =~ /#{pool}\d/
          game.home = sorted_teams[ game.home_prereq_uid.gsub(pool, '').to_i - 1 ]
          game.reset!
          game.save!
        end

        if game.away_prereq_uid =~ /#{pool}\d/
          game.away = sorted_teams[ game.away_prereq_uid.gsub(pool, '').to_i - 1 ]
          game.reset!
          game.save!
        end
      end
    end

    def push_places
      division.places.each do |place|
        if place.prereq_uid =~ /#{pool}\d/
          place.team = sorted_teams[ place.prereq_uid.gsub(pool, '').to_i - 1 ]
          place.save!
        end
      end
    end

    #TODO is this how tie breakers should be done?
    def sorted_teams
      @sorted_teams ||= begin
        teams = teams_for_pool(pool).order(
          wins: :desc, points_for: :desc
        )
      end
    end

    def teams_for_pool(pool)
      team_ids = division.games
        .where(pool: pool)
        .pluck(:home_id, :away_id)
        .flatten.uniq

      division.teams.where(id: team_ids)
    end
  end
end
