require 'test_helper'

class DivisionSeedTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @tournament = FactoryGirl.create(:tournament)
  end

  test "initializes the first round" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(@tournament, params)

    teams = (1..8).map do |seed|
      FactoryGirl.create(:team, division: division, seed: seed)
    end

    perform_operation(division, teams)

    games = division.games.where(bracket_uid: ['q1', 'q2', 'q3', 'q4'])

    games.each do |game|
      assert_equal game.home, teams[game.home_prereq.to_i - 1]
      assert_equal game.away, teams[game.away_prereq.to_i - 1]
    end
  end

  test "resets any games past the seed round" do
    user = FactoryGirl.create(:user)
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(@tournament, params)

    teams = (1..8).map do |seed|
      FactoryGirl.create(:team, division: division, seed: seed)
    end

    perform_operation(division, teams)

    round1_games = division.games.where(bracket_uid: ['q1', 'q2', 'q3', 'q4'])
    round2_games = division.games.where(bracket_uid: ['s1', 's2', 'c3', 'c4'])

    perform_enqueued_jobs do
      round1_games.each do |game|
        GameUpdateScore.perform(
          game: game,
          user: user,
          home_score: 15,
          away_score: 13,
        )
      end
    end

    round2_games.reload
    assert round2_games.all?{ |g| g.teams_present? }

    perform_operation(division, teams, 'true')

    round2_games.reload
    assert round2_games.all?{ |g| not g.teams_present? }
    assert round2_games.all?{ |g| not g.confirmed? }
  end

  test "round robin 5 (seeds into round 2 games)" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'round_robin_5')
    division = create_division(@tournament, params)

    teams = (1..5).map do |seed|
      FactoryGirl.create(:team, division: division, seed: seed)
    end

    perform_operation(division, teams)

    game = division.games.find_by(bracket_uid: 'rr3')
    assert_nil game.home
    assert_equal teams.first, game.away
  end

  test "sets division seeded to true" do
    params = FactoryGirl.attributes_for(:division, bracket_type: 'single_elimination_8')
    division = create_division(@tournament, params)

    teams = (1..8).map do |seed|
      FactoryGirl.create(:team, division: division, seed: seed)
    end

    refute division.seeded?

    perform_operation(division, teams)

    assert division.reload.seeded?
  end

  private

  def create_division(tournament, params)
    DivisionCreate.perform(tournament: tournament, division_params: params)
  end

  def perform_operation(division, teams, confirm = 'false')
    DivisionSeed.perform(
      division: division,
      team_ids: teams.map(&:id),
      seeds: teams.map(&:seed),
      confirm: confirm
    )
  end
end
