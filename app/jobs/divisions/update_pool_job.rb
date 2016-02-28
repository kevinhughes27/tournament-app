module Divisions
  class UpdatePoolJob < ActiveJob::Base
    queue_as :default

    attr_reader :division, :pool

    def perform(division:, pool:)
      @division, @pool = division, pool
      reseed if pool_finished?
    end

    private

    def pool_finished?
      tournament_id = division.tournament_id

      games = Game.where(tournament_id: tournament_id, division_id: division.id, pool: pool)
      games.all? { |game| game.confirmed? }
    end

    def reseed
      team_ids = division.team_ids_for_pool(pool)
      teams = division.teams.where(id: team_ids)

      #TODO is this how tie breakers should be done?
      teams = teams.order(wins: :desc, points_for: :desc)

      division.games.each do |game|
        if game.home_prereq_uid =~ /#{pool}\d/
          game.home = teams[ game.home_prereq_uid.gsub(pool, '').to_i - 1 ]
          game.home_score = nil
          game.away_score = nil
          game.score_confirmed = false
          game.save!
        end

        if game.away_prereq_uid =~ /#{pool}\d/
          game.away = teams[ game.away_prereq_uid.gsub(pool, '').to_i - 1 ]
          game.home_score = nil
          game.away_score = nil
          game.score_confirmed = false
          game.save!
        end
      end
    end
  end
end
