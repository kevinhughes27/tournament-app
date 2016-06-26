module Divisions
  class FinishPoolJob < ApplicationJob
    attr_reader :division, :pool

    def perform(division:, pool:)
      @division, @pool = division, pool
      return unless pool_finished?
      clear_results
      record_results
      reseed
      push_places
    end

    private

    def pool_finished?
      Division::pool_finished?(
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

    def clear_results
      PoolResult.where(
        tournament_id: division.tournament_id,
        division_id: division.id,
        pool: pool,
      ).destroy_all
    end

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
      prereq_uid =~ /#{pool}\d/
    end

    def team_for_prereq(prereq_uid)
      sorted_teams[ pool_place_index_from_prereq(prereq_uid) ]
    end

    def pool_place_index_from_prereq(prereq_uid)
      prereq_uid.gsub(pool, '').to_i - 1
    end

    def sorted_teams
      @sorted_teams ||= begin

        team_wins = Hash.new(0)
        team_pts = Hash.new(0)
        games_for_pool.each do |game|
          if game.tie?
            team_wins[game.home_id] += 1
            team_wins[game.away_id] += 1
          else
            team_wins[game.winner.id] += 1
          end

          team_pts[game.home_id] += game.home_score
          team_pts[game.away_id] += game.away_score
        end

        teams = teams_for_pool.sort_by do |team|
          [team_wins[team.id], team_pts[team.id]]
        end.reverse

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
