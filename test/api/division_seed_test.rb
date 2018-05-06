require 'test_helper'

class DivisionSeedTest < ApiTest
  setup do
    login_user
    @output = '{ success, confirm, errors }'
  end

  test "seed a division" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_4')
    division = create_division(params)
    teams = create_teams(division, 4)

    input = {division_id: division.id}
    execute_graphql("divisionSeed", "DivisionSeedInput", input, @output)
    assert_success
  end

  test "seed (unsafe)" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_4')
    division = create_division(params)
    teams = create_teams(division, 4)

    FactoryGirl.create(:game, :finished, division: division, home: teams.first)

    assert division.teams.any?{ |t| !t.allow_change? }

    team1 = division.teams.first
    team2 = division.teams.last

    input = {
      division_id: division.id,
      team_ids: [team1.id, team2.id],
      seeds: [team2.seed, team1.seed]
    }

    execute_graphql("divisionSeed", "DivisionSeedInput", input, @output)
    assert_confirmation_required "This division has games that have been scored. Seeding this division will reset those games. Are you sure this is what you want to do?"
  end

  test "seed a division with an error" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_4')
    division = create_division(params)
    teams = create_teams(division, 8)

    input = {division_id: division.id}
    execute_graphql("divisionSeed", "DivisionSeedInput", input, @output)
    assert_failure '4 seats but 8 teams present'
  end

  test "initializes the first round" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(params)
    teams = create_teams(division, 8)

    input = {division_id: division.id}
    execute_graphql("divisionSeed", "DivisionSeedInput", input, @output)
    assert_success

    games = division.games.where(bracket_uid: ['q1', 'q2', 'q3', 'q4'])

    games.each do |game|
      assert_equal game.home, teams[game.home_prereq.to_i - 1]
      assert_equal game.away, teams[game.away_prereq.to_i - 1]
    end
  end

  test "resets any games past the seed round" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(params)
    teams = create_teams(division, 8)

    input = {division_id: division.id}
    execute_graphql("divisionSeed", "DivisionSeedInput", input, @output)
    assert_success

    round1_games = division.games.where(bracket_uid: ['q1', 'q2', 'q3', 'q4'])
    round2_games = division.games.where(bracket_uid: ['s1', 's2', 'c3', 'c4'])

    round1_games.each do |game|
      update_game_score(game)
    end

    round2_games.reload
    assert round2_games.all?{ |g| g.teams_present? }

    input = {division_id: division.id, confirm: true}
    execute_graphql("divisionSeed", "DivisionSeedInput", input, @output)
    assert_success

    round2_games.reload
    assert round2_games.all?{ |g| not g.teams_present? }
    assert round2_games.all?{ |g| not g.confirmed? }
  end

  test "round robin 5 (seeds into round 2 games)" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'round_robin_5')
    division = create_division(params)
    teams = create_teams(division, 5)

    input = {division_id: division.id}
    execute_graphql("divisionSeed", "DivisionSeedInput", input, @output)
    assert_success

    game = division.games.find_by(bracket_uid: 'rr3')
    assert_nil game.home
    assert_equal teams.first, game.away
  end

  test "sets division seeded to true" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(params)
    teams = create_teams(division, 8)

    refute division.seeded?

    input = {division_id: division.id}
    execute_graphql("divisionSeed", "DivisionSeedInput", input, @output)
    assert_success

    assert division.reload.seeded?
  end

  private

  def create_division(params)
    input = params.except(:tournament)
    execute_graphql("divisionCreate", "DivisionCreateInput", input)
    assert_success
    Division.last
  end

  def create_teams(division, num)
    (1..num).map do |seed|
      FactoryGirl.create(:team, division: division, seed: seed)
    end
  end

  def update_game_score(game)
    input = {game_id: game.id, home_score: 15, away_score: 13}
    execute_graphql("gameUpdateScore", "GameUpdateScoreInput", input)
    assert_success
  end
end
