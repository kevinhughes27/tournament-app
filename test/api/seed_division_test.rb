require 'test_helper'

class SeedDivisionTest < ApiTest
  setup do
    login_user
    @output = '{ success confirm message }'
  end

  test "seed a division" do
    params = FactoryBot.attributes_for(:division, bracket_type: 'single_elimination_4')
    division = create_division(params)
    seeds = create_seeds(division, 4)

    input = {division_id: division.id}
    execute_graphql("seedDivision", "SeedDivisionInput", input, @output)
    assert_success
  end

  test "seed (unsafe)" do
    params = FactoryBot.attributes_for(:division, bracket_type: 'single_elimination_4')
    division = create_division(params)
    seeds = create_seeds(division, 4)

    FactoryBot.create(:game, :finished, division: division, home: seeds.first.team)

    assert division.teams.any?{ |t| !t.allow_delete? }

    input = {division_id: division.id}
    execute_graphql("seedDivision", "SeedDivisionInput", input, @output)
    assert_confirmation_required "This division has games that have been scored. Seeding this division will reset those games. Are you sure this is what you want to do?"
  end

  test "seed a division with an error" do
    params = FactoryBot.attributes_for(:division, bracket_type: 'single_elimination_4')
    division = create_division(params)
    seeds = create_seeds(division, 8)

    input = {division_id: division.id}
    execute_graphql("seedDivision", "SeedDivisionInput", input, @output)
    assert_failure '4 seats but 8 teams present'
  end

  test "initializes the first round" do
    params = FactoryBot.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(params)
    seeds = create_seeds(division, 8)

    input = {division_id: division.id}
    execute_graphql("seedDivision", "SeedDivisionInput", input, @output)
    assert_success

    games = division.games.where(bracket_uid: ['q1', 'q2', 'q3', 'q4'])

    games.each do |game|
      assert_equal game.home, seeds[game.home_prereq.to_i - 1].team
      assert_equal game.away, seeds[game.away_prereq.to_i - 1].team
    end
  end

  test "resets any games past the seed round" do
    params = FactoryBot.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(params)
    seeds = create_seeds(division, 8)

    input = {division_id: division.id}
    execute_graphql("seedDivision", "SeedDivisionInput", input, @output)
    assert_success

    round1_games = division.games.where(bracket_uid: ['q1', 'q2', 'q3', 'q4'])
    round2_games = division.games.where(bracket_uid: ['s1', 's2', 'c3', 'c4'])

    round1_games.each do |game|
      update_game_score(game)
    end

    round2_games.reload
    assert round2_games.all?{ |g| g.teams_present? }

    input = {division_id: division.id, confirm: true}
    execute_graphql("seedDivision", "SeedDivisionInput", input, @output)
    assert_success

    round2_games.reload
    assert round2_games.all?{ |g| not g.teams_present? }
    assert round2_games.all?{ |g| not g.confirmed? }
  end

  test "round robin 5 (seeds into round 2 games)" do
    params = FactoryBot.attributes_for(:division, bracket_type: 'round_robin_5')
    division = create_division(params)
    seeds = create_seeds(division, 5)

    input = {division_id: division.id}
    execute_graphql("seedDivision", "SeedDivisionInput", input, @output)
    assert_success

    game = division.games.find_by(bracket_uid: 'rr3')
    assert_nil game.home
    assert_equal seeds.first.team, game.away
  end

  test "sets division seeded to true" do
    params = FactoryBot.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(params)
    seeds = create_seeds(division, 8)

    refute division.seeded?

    input = {division_id: division.id}
    execute_graphql("seedDivision", "SeedDivisionInput", input, @output)
    assert_success

    assert division.reload.seeded?
  end

  private

  def create_division(params)
    input = params.except(:tournament)
    execute_graphql("createDivision", "CreateDivisionInput", input)
    assert_success
    Division.last
  end

  def create_seeds(division, num)
    (1..num).map do |seed|
      FactoryBot.create(:seed, division: division, seed: seed)
    end
  end

  def update_game_score(game)
    input = {game_id: game.id, home_score: 15, away_score: 13}
    execute_graphql("updateScore", "UpdateScoreInput", input)
    assert_success
  end
end
