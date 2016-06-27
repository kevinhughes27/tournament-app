class Pool
  attr_reader :division, :uid

  def initialize(division, uid)
    @division = division
    @uid = uid
  end

  def finished?
    games.all? { |game| game.confirmed? }
  end

  def results(updated_game: nil, home_score: nil, away_score: nil)
    @results ||= begin
      team_wins = Hash.new(0)
      team_pts = Hash.new(0)

      games.each do |game|
        if updated_game == game
          game.home_score = home_score
          game.away_score = away_score
        end

        if game.tie?
          team_wins[game.home_id] += 1
          team_wins[game.away_id] += 1
        else
          team_wins[game.winner.id] += 1
        end

        team_pts[game.home_id] += game.home_score
        team_pts[game.away_id] += game.away_score
      end

      sorted_teams = teams.sort_by do |team|
        [team_wins[team.id], team_pts[team.id]]
      end.reverse

      sorted_teams
    end
  end

  def results_changed?(game, home_score, away_score)
    old_results = persisted_results.order(position: :asc)
    new_results = results(updated_game: game, home_score: home_score, away_score: away_score)

    new_results.each_with_index do |team, idx|
      return true if old_results[idx].try(:team) != team
    end
    false
  end

  def persist_results
    results.each_with_index do |team, idx|
      position = idx + 1
      PoolResult.create!(
        tournament_id: division.tournament_id,
        division_id: division.id,
        pool: uid,
        position: position,
        team: team
      )
    end
  end

  def clear_results
    persisted_results.destroy_all
  end

  private

  def teams
    team_ids = division.games
      .where(pool: uid)
      .pluck(:home_id, :away_id)
      .flatten.uniq

    division.teams.where(id: team_ids)
  end

  def games
    @games ||= division.games.where(pool: uid)
  end

  def persisted_results
    PoolResult.where(
      tournament_id: division.tournament_id,
      division_id: division.id,
      pool: uid,
    )
  end
end
