require 'test_helper'

class GameTest < ActiveSupport::TestCase

  test "valid_for_seed_round? returns true if both top and bottom are integers" do
    game = Game.new(bracket_top: 1, bracket_bottom: 8)
    assert game.valid_for_seed_round?
  end

  test "valid_for_seed_round? returns true if both top and bottom are integer string" do
    game = Game.new(bracket_top: 1, bracket_bottom: "8")
    assert game.valid_for_seed_round?
  end

  test "valid_for_seed_round? returns false if either top or bottom are not integers" do
    game = Game.new(bracket_top: 1, bracket_bottom: 'A1')
    refute game.valid_for_seed_round?

    game = Game.new(bracket_top: 'B1', bracket_bottom: 'A1')
    refute game.valid_for_seed_round?
  end

  test "game pushes its winner through the bracket when its score is confirmed" do
    home = teams(:swift)
    away = teams(:goose)

    game1 = Game.create(bracket_uid: 'q1', home: home, away: away)
    game2 = Game.create(bracket_uid: 'q1', bracket_top: 'wq1', bracket_bottom: 'wq2')

    game1.confirm_score(15, 11)

    assert_equal home, game2.reload.home
  end

  test "game pushes its loser through the bracket when its score is confirmed" do
    home = teams(:swift)
    away = teams(:goose)

    game1 = Game.create(bracket_uid: 'q1', home: home, away: away)
    game2 = Game.create(bracket_uid: 'q1', bracket_top: 'lq2', bracket_bottom: 'lq1')

    game1.confirm_score(15, 11)

    assert_equal away, game2.reload.away
  end

end
