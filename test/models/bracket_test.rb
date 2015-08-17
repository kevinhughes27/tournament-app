require 'test_helper'

class BracketTest < ActiveSupport::TestCase

  setup do
    @tournament = tournaments(:noborders)
    @teams = @tournament.teams
  end

  test "types returns all templates" do
    assert Bracket.types.include? 'single_elimination_8'
    assert Bracket.types.include? 'single_elimination_4'
  end

  test "bracket_uids_for_round returns the uids for the given round" do
    type = 'single_elimination_8'
    bracket = Bracket.create(tournament: @tournament, bracket_type: type)
    assert_equal ['q1', 'q2', 'q3', 'q4'], bracket.bracket_uids_for_round(1)
  end

  test "bracket creates all required games" do
    type = 'single_elimination_8'

    assert_difference "Game.count", +12 do
      Bracket.create(tournament: @tournament, bracket_type: type)
    end
  end

  test "bracket deletes games when it is deleted" do
    type = 'single_elimination_8'
    bracket = Bracket.create(tournament: @tournament, bracket_type: type)

    assert_difference "Game.count", -12 do
      bracket.destroy
    end
  end

  test "bracket creates games as spec'd by the bracket template" do
    type = 'single_elimination_8'
    template = load_template(type)
    template_game = template[:games].first

    bracket = Bracket.create(tournament: @tournament, bracket_type: type)

    game = Game.find_by(bracket: bracket, bracket_uid: template_game[:uid])

    assert game
    assert_equal template_game[:top].to_s, game.bracket_top
    assert_equal template_game[:bottom].to_s, game.bracket_bottom
  end

  test "seed takes a sorted list of teams and enters the first round of the bracket" do
    type = 'single_elimination_8'
    bracket = Bracket.create(tournament: @tournament, bracket_type: type)
    bracket.seed(@teams, 1)

    @teams.sort_by{ |t| t.seed }
    games = bracket.games.where(bracket_uid: ['q1', 'q2', 'q3', 'q4'])

    games.each do |game|
      assert_equal game.home, @teams[game.bracket_top.to_i - 1]
      assert_equal game.away, @teams[game.bracket_bottom.to_i - 1]
    end
  end

  test "seed raises if any games are invalid for a seed round" do
    type = 'single_elimination_8'
    bracket = Bracket.create(tournament: @tournament, bracket_type: type)

    assert_raises Bracket::InvalidSeedRound do
      bracket.seed(@teams, 2)
    end
  end

  test "updating the bracket_type clears the previous games" do
    bracket = Bracket.create(tournament: @tournament, bracket_type: 'single_elimination_8')
    assert_equal 12, bracket.games.count
    bracket.update_attributes(bracket_type: 'single_elimination_4')
    assert_equal 4, bracket.games.count
  end

  private

  def load_template(type)
    path = Rails.root.join("db/brackets/#{type}.json")
    file = File.read(path)
    JSON.parse(file).with_indifferent_access
  end
end
