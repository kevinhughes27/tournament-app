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

end
