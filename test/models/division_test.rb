require 'test_helper'

class DivisionTest < ActiveSupport::TestCase

  setup do
    @tournament = tournaments(:noborders)
    @teams = @tournament.teams.order(:seed)
  end

  test "division creates all required games" do
    type = 'single_elimination_8'
    assert_difference "Game.count", +12 do
      Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)
    end
  end

  test "division deletes games when it is deleted" do
    type = 'single_elimination_8'
    division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)

    assert_difference "Game.count", -12 do
      division.destroy
    end
  end

  test "division nullifies teams when it is deleted" do
    division = divisions(:open)

    teams = division.teams
    assert teams.present?

    division.destroy

    assert teams.reload.all? { |team| team.division.nil? }
  end

  test "division creates games as spec'd by the bracket template" do
    type = 'single_elimination_8'
    template = Bracket.find_by(name: type).template
    template_game = template[:games].first

    division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)

    game = Game.find_by(division: division, bracket_uid: template_game[:uid])

    assert game
    assert_equal template_game[:home].to_s, game.home_prereq_uid
    assert_equal template_game[:away].to_s, game.away_prereq_uid
  end

  test "seed initializes the first round" do
    type = 'single_elimination_8'
    division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)
    @teams.update_all(division_id: division.id)

    division.seed(1)

    @teams.sort_by{ |t| t.seed }
    games = division.games.where(bracket_uid: ['q1', 'q2', 'q3', 'q4'])

    games.each do |game|
      assert_equal game.home, @teams[game.home_prereq_uid.to_i - 1]
      assert_equal game.away, @teams[game.away_prereq_uid.to_i - 1]
    end
  end

  test "seed raises if any games are invalid for a seed round" do
    type = 'single_elimination_8'
    division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)
    @teams.update_all(division_id: division.id)

    assert_raises Division::InvalidSeedRound do
      division.seed(2)
    end
  end

  test "seed resets any games past the seed round" do
    type = 'single_elimination_8'
    division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)
    @teams.update_all(division_id: division.id)

    division.seed(1)

    round1_games = division.games.where(bracket_uid: ['q1', 'q2', 'q3', 'q4'])
    round2_games = division.games.where(bracket_uid: ['s1', 's2', 'c3', 'c4'])

    round1_games.each do |game|
      game.update_score(15,13)
    end

    assert = round2_games.all?{ |g| g.teams_present? }
    division.seed(1)
    assert = round2_games.all?{ |g| not g.teams_present? }
  end

  test "seed round robin 5" do
    type = 'round_robin_5'
    @teams[5..-1].map(&:destroy)
    @teams.reload

    division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)
    @teams.update_all(division_id: division.id)

    division.seed(1)

    game = division.games.find_by(bracket_uid: 'rr3')
    assert_nil game.home
    assert_equal @teams.first, game.away
  end

  test "dirty_seed?" do
    type = 'single_elimination_8'
    division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: type)
    @teams.update_all(division_id: division.id)

    refute division.seeded?
    assert division.dirty_seed?

    division.seed(1)

    assert division.seeded?
    refute division.dirty_seed?

    division.teams[0].update_attributes(seed: 2)
    division.teams[1].update_attributes(seed: 1)

    assert division.dirty_seed?
  end

  test "updating the bracket_type clears the previous games" do
    division = Division.create!(tournament: @tournament, name: 'New Division', bracket_type: 'single_elimination_8')
    assert_equal 12, division.games.count
    division.update_attributes(bracket_type: 'single_elimination_4')
    assert_equal 4, division.games.count
  end
end
