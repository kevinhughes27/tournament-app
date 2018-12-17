require 'test_helper'

class FinishPoolTest < OperationTest
  include ActiveJob::TestHelper

  setup do
    params = FactoryBot.attributes_for(:division, bracket_type: 'USAU 8.1')
    @division = create_division(params)
    @seeds = create_seeds(@division, 8)
  end

  test "pool not finished" do
    Game.any_instance.expects(:save!).never
    pool = Pool.new(@division, 'A')
    FinishPool.perform(pool)
  end

  test "records pool results" do
    seed_division(@division)
    play_pool(@division, 'A')

    assert_difference 'PoolResult.count', +4 do
      pool = Pool.new(@division, 'A')
      FinishPool.perform(pool)
    end
  end

  test "clears previous pool results" do
    seed_division(@division)
    play_pool(@division, 'A')

    result = PoolResult.create!(
      tournament_id: @tournament.id,
      division_id: @division.id,
      pool: 'A',
      position: 1,
      team: @seeds.first.team,
      wins: 1,
      points: 10
    )

    assert_difference 'PoolResult.count', +3 do
      pool = Pool.new(@division, 'A')
      FinishPool.perform(pool)
    end

    assert_raises ActiveRecord::RecordNotFound do
      result.reload
    end
  end

  test "update pool" do
    seed_division(@division)
    play_pool(@division, 'A')

    pool = Pool.new(@division, 'A')
    FinishPool.perform(pool)

    game1 = @division.games.find_by(home_prereq: 'A1')
    game2 = @division.games.find_by(away_prereq: 'A4')

    assert_equal @seeds.first.team, game1.home
    assert_equal @seeds.last.team, game2.away
  end

  test "update pool using points_for for tie breaker" do
    division = FactoryBot.create(:division)
    seeds = create_seeds(division, 4)

    FactoryBot.create(:game,
      division: division,
      pool: 'A',
      round: 1,
      home_prereq: 1,
      away_prereq: 2,
      home_pool_seed: 1,
      away_pool_seed: 2,
      home: seeds[0].team,
      away: seeds[1].team,
      home_score: 5,
      away_score: 0
    )

    FactoryBot.create(:game,
      division: division,
      pool: 'A',
      round: 1,
      home_prereq: 3,
      away_prereq: 4,
      home_pool_seed: 3,
      away_pool_seed: 4,
      home: seeds[2].team,
      away: seeds[3].team,
      home_score: 10,
      away_score: 2
    )

    pool = Pool.new(division, 'A')
    FinishPool.perform(pool)

    results = division.pool_results.order(:position)

    assert_equal seeds[2].team, results[0].team
    assert_equal 1, results[0].wins
    assert_equal 10, results[0].points

    assert_equal seeds[0].team, results[1].team
    assert_equal 1, results[1].wins
    assert_equal 5, results[1].points

    assert_equal seeds[3].team, results[2].team
    assert_equal 0, results[2].wins
    assert_equal 2, results[2].points

    assert_equal seeds[1].team, results[3].team
    assert_equal 0, results[3].wins
    assert_equal 0, results[3].points
  end

  test "update pool using points_for for tie breaker with a tie game" do
    division = FactoryBot.create(:division)
    seeds = create_seeds(division, 4)

    FactoryBot.create(:game,
      division: division,
      pool: 'A',
      round: 1,
      home_prereq: 1,
      away_prereq: 2,
      home_pool_seed: 1,
      away_pool_seed: 2,
      home: seeds[0].team,
      away: seeds[1].team,
      home_score: 10,
      away_score: 0
    )

    FactoryBot.create(:game,
      division: division,
      pool: 'A',
      round: 1,
      home_prereq: 3,
      away_prereq: 4,
      home_pool_seed: 3,
      away_pool_seed: 4,
      home: seeds[2].team,
      away: seeds[3].team,
      home_score: 5,
      away_score: 2
    )

    FactoryBot.create(:game,
      division: division,
      pool: 'A',
      round: 1,
      home_prereq: 1,
      away_prereq: 3,
      home_pool_seed: 1,
      away_pool_seed: 3,
      home: seeds[0].team,
      away: seeds[2].team,
      home_score: 10,
      away_score: 10
    )

    pool = Pool.new(division, 'A')
    FinishPool.perform(pool)

    results = division.pool_results.order(:position)

    assert_equal seeds[0].team, results[0].team
    assert_equal seeds[2].team, results[1].team
    assert_equal seeds[3].team, results[2].team
    assert_equal seeds[1].team, results[3].team
  end

  test "update pool resets dependent bracket games" do
    seed_division(@division)
    play_pool(@division, 'A')

    game1 = @division.games.find_by(home_prereq: 'A1')
    game2 = @division.games.find_by(away_prereq: 'A4')

    # finish the pool and advance teams
    perform_enqueued_jobs do
      pool = Pool.new(@division, 'A')
      FinishPool.perform(pool)

      assert_equal @seeds.first.team, game1.reload.home
      assert_equal @seeds.last.team, game2.reload.away
    end

    # mark dependent games as confirmed
    game1.update_column(:score_confirmed, true)
    game2.update_column(:score_confirmed, true)

    # reverse wins in the pool
    @division.games.where(pool: 'A').each do |game|
      game.update_columns(
        home_score: game.away_score,
        away_score: game.home_score
      )
    end

    # force reload the games
    @division.reload

    # finish the pool again  - resets dependent games
    perform_enqueued_jobs do
      pool = Pool.new(@division, 'A')
      FinishPool.perform(pool)

      refute game1.reload.confirmed?
      refute game2.reload.confirmed?
    end
  end

  test "update pool doesn't reset dependent bracket games if no change" do
    seed_division(@division)
    play_pool(@division, 'A')

    game1 = @division.games.find_by(home_prereq: 'A1')
    game2 = @division.games.find_by(away_prereq: 'A4')

    # finish the pool and advance teams
    perform_enqueued_jobs do
      pool = Pool.new(@division, 'A')
      FinishPool.perform(pool)

      assert_equal @seeds.first.team, game1.reload.home
      assert_equal @seeds.last.team, game2.reload.away
    end

    game1.update_column(:score_confirmed, true)
    game2.update_column(:score_confirmed, true)

    # force reload the games
    @division.reload

    # finish the pool again (no change)
    perform_enqueued_jobs do
      pool = Pool.new(@division, 'A')
      FinishPool.perform(pool)

      assert game1.reload.confirmed?
      assert game2.reload.confirmed?
    end
  end

  private

  def create_division(params)
    input = params.except(:tournament)
    execute_graphql("createDivision", "CreateDivisionInput", input)
    Division.last
  end

  def create_seeds(division, num)
    (1..num).map do |rank|
      FactoryBot.create(:seed, division: division, rank: rank)
    end
  end

  def seed_division(division)
    execute_graphql("seedDivision", "SeedDivisionInput", {division_id: division.id})
    division.reload
  end

  def play_pool(division, pool)
    division.games.where(pool: pool).each do |game|
      home_score = game.home_id < game.away_id ? 2 : 1
      away_score = game.home_id < game.away_id ? 1 : 2
      game.update_columns(
        home_score: home_score,
        away_score: away_score,
        score_confirmed: true
      )
    end
  end
end
