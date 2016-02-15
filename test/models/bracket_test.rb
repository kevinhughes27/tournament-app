require 'test_helper'

class BracketTest < ActiveSupport::TestCase
  test "types returns each type" do
    assert Bracket.types.include? 'single_elimination_8'
    assert Bracket.types.include? 'single_elimination_4'
  end

  test "types_with_num returns each type with the number of teams" do
    assert Bracket.types_with_num.include? ['single_elimination_8', 8]
    assert Bracket.types_with_num.include? ['single_elimination_4', 4]
  end
end
