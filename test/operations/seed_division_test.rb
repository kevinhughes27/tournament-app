require 'test_helper'

class SeedDivisionTest < ActiveSupport::TestCase
  include ActiveJob::TestHelper

  setup do
    @tournament = tournaments(:noborders)
    @user = users(:bob)
    @division = divisions(:open)
    @teams = @division.teams.order(:seed)
  end

  test "initializes the first round" do
    division = new_division('single_elimination_8')

    teams = @teams.to_a
    @teams.update_all(division_id: division.id)

    SeedDivision.perform(division)

    teams.sort_by{ |t| t.seed }
    games = division.games.where(bracket_uid: ['q1', 'q2', 'q3', 'q4'])

    games.each do |game|
      assert_equal game.home, teams[game.home_prereq.to_i - 1]
      assert_equal game.away, teams[game.away_prereq.to_i - 1]
    end
  end

  test "halts if any games are invalid for a seed round" do
    division = new_division('single_elimination_8')
    @teams.update_all(division_id: division.id)

    division.games.first.update_columns(
      home_prereq: 'NaN',
      away_prereq: 'NaN'
    )

    seed = SeedDivision.new(division)
    seed.perform

    assert seed.halted?
    assert_equal 'Invalid seed round', seed.message
  end

  test "resets any games past the seed round" do
    division = new_division('single_elimination_8')
    @teams.update_all(division_id: division.id)

    SeedDivision.perform(division)

    round1_games = division.games.where(bracket_uid: ['q1', 'q2', 'q3', 'q4'])
    round2_games = division.games.where(bracket_uid: ['s1', 's2', 'c3', 'c4'])

    perform_enqueued_jobs do
      round1_games.each do |game|
        GameUpdateScore.perform(
          game: game,
          user: @user,
          home_score: 15,
          away_score: 13,
        )
      end
    end

    round2_games.reload
    assert round2_games.all?{ |g| g.teams_present? }

    SeedDivision.perform(division, 'true')

    round2_games.reload
    assert round2_games.all?{ |g| not g.teams_present? }
    assert round2_games.all?{ |g| not g.confirmed? }
  end

  test "round robin 5" do
    division = new_division('round_robin_5')
    @teams[5..-1].map(&:destroy)
    teams = @teams.reload
    @teams.update_all(division_id: division.id)

    SeedDivision.perform(division)

    game = division.games.find_by(bracket_uid: 'rr3')
    assert_nil game.home
    assert_equal teams.first, game.away
  end

  test "sets division seeded to true" do
    division = new_division('single_elimination_8')

    teams = @teams.to_a
    @teams.update_all(division_id: division.id)

    refute division.seeded?

    SeedDivision.perform(division)

    assert division.reload.seeded?
  end

  private

  def new_division(type)
    perform_enqueued_jobs do
      division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)
    end
  end
end
