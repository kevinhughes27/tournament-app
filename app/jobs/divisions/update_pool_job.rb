module Divisions
  class UpdatePoolJob < ActiveJob::Base
    queue_as :default

    attr_reader :division, :pool

    def perform(division:, pool:)
      @division, @pool = division, pool
      if pool_finished?
        reseed
        push_places
      end
    end

    private

    def pool_finished?
      tournament_id = division.tournament_id
      games = Game.where(tournament_id: tournament_id, division_id: division.id, pool: pool)
      games.all? { |game| game.confirmed? }
    end

    def reseed
      division.games.each do |game|
        if game.home_prereq_uid =~ /#{pool}\d/
          game.home = sorted_teams[ game.home_prereq_uid.gsub(pool, '').to_i - 1 ]
          game.home_score = nil
          game.away_score = nil
          game.score_confirmed = false
          game.save!
        end

        if game.away_prereq_uid =~ /#{pool}\d/
          game.away = sorted_teams[ game.away_prereq_uid.gsub(pool, '').to_i - 1 ]
          game.home_score = nil
          game.away_score = nil
          game.score_confirmed = false
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
