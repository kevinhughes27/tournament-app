module Divisions
  class UpdatePoolJob < ApplicationJob
    queue_as :default

    attr_reader :division, :pool

    def perform(division:, pool:)
      @division, @pool = division, pool
      return unless pool_finished?
      record_results
      reseed
      push_places
    end

    private

    def pool_finished?
      Divisions::PoolFinishedJob.perform_now(
        tournament_id: division.tournament_id,
        division_id: division.id,
        pool: pool
      )
    end

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
        changed = false

        if game.home_prereq_uid =~ /#{pool}\d/
          game.home = sorted_teams[ game.home_prereq_uid.gsub(pool, '').to_i - 1 ]
          changed = true
        end

        if game.away_prereq_uid =~ /#{pool}\d/
          game.away = sorted_teams[ game.away_prereq_uid.gsub(pool, '').to_i - 1 ]
          changed = true
        end

        next unless changed

        if game.confirmed?
          game.reset!
          Divisions::ResetBracketJob.perform_later(game_id: game.id)
        end

        game.save!
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

    def sorted_teams
      @sorted_teams ||= begin

        team_wins = Hash.new(0)
        team_pts = Hash.new(0)
        games_for_pool.each do |game|
          team_wins[game.winner.id] += 1
          team_pts[game.home_id] += game.home_score
          team_pts[game.away_id] += game.away_score
        end

        teams = teams_for_pool.sort_by do |team|
          [team_wins[team.id], team_pts[team.id]]
        end

        teams
      end
    end

    def teams_for_pool
      team_ids = division.games
        .where(pool: pool)
        .pluck(:home_id, :away_id)
        .flatten.uniq

      division.teams.where(id: team_ids)
    end

    def games_for_pool
      division.games.where(pool: pool)
    end
  end
end
