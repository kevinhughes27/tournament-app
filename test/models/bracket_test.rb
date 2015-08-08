require 'test_helper'

class BracketTest < ActiveSupport::TestCase

  setup do
    @tournament = tournaments(:noborders)
    @teams = @tournament.teams
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
    bracket.seed(teams)

    game1 = bracket.games.first
    game2 = bracket.games.last

    assert_equal game1.home, teams[game1.bracket_top.to_i + 1]
    assert_equal game1.away, teams[game1.bracket_bottom.to_i + 1]
    assert_equal game2.home, teams[game2.bracket_top.to_i + 1]
    assert_equal game2.away, teams[game2.bracket_bottom.to_i + 1]
  end

  test "seed raises if any games are invalid for a seed round" do
    type = 'single_elimination_8'
    bracket = Bracket.create(tournament: @tournament, bracket_type: type)

    assert_raises Bracket::InvalidSeedRound do
      bracket.seed(teams, 2)
    end
  end

  private

  def load_template(type)
    path = Rails.root.join("db/brackets/#{type}.json")
    file = File.read(path)
    JSON.parse(file).with_indifferent_access
  end
end
