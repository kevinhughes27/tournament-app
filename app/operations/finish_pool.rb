class FinishPool < ComposableOperations::Operation
  processes :pool
  property :pool, accepts: Pool, required: true

  attr_reader :division

  def execute
    halt 'pool is not finished' unless pool.finished?
    @division = pool.division

    pool.clear_results
    pool.persist_results
    reseed
    push_places
  end

  private

  def reseed
    division.games.each do |game|

      if prereq_from_pool?(game.home_prereq)
        team = team_for_prereq(game.home_prereq)
        game.home = team
      end

      if prereq_from_pool?(game.away_prereq)
        team = team_for_prereq(game.away_prereq)
        game.away = team
      end

      next unless game.changed?

      if game.confirmed?
        game.reset_score!
        Divisions::ResetBracketJob.perform_later(game_id: game.id)
      end

      game.save!
    end
  end

  def push_places
    division.places.each do |place|
      if prereq_from_pool?(place.prereq)
        place.team = team_for_prereq(place.prereq)
        place.save!
      end
    end
  end

  def prereq_from_pool?(prereq)
    prereq =~ /#{pool.uid}\d/
  end

  def team_for_prereq(prereq)
    pool.results[ pool_place_index_from_prereq(prereq) ]
  end

  def pool_place_index_from_prereq(prereq)
    prereq.gsub(pool.uid, '').to_i - 1
  end
end
