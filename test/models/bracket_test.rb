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

  test "game_uids_for_round returns the uids for the given round" do
    bracket = Bracket.find_by(name: 'single_elimination_8')
    assert_equal ['q1', 'q2', 'q3', 'q4'], bracket.game_uids_for_round(1)
  end

  BracketTemplateValidator.methods(false).each do |validation|
    next unless validation.to_s.include? 'validate_'
    Bracket.all.each do |bracket|
      test "bracket template #{validation} #{bracket.name}" do
        assert BracketTemplateValidator.send(validation, bracket.template)
      end
    end
  end
end
