require 'test_helper'

class BracketTest < ActiveSupport::TestCase
  test "game_uids_for_round returns the uids for the given round" do
    bracket = Bracket.find_by(handle: 'single_elimination_8')
    assert_equal ['q1', 'q2', 'q3', 'q4'], bracket.game_uids_for_round(1)
  end

  BracketTemplateValidator.methods(false).each do |validation|
    next unless validation.to_s.include? 'validate_'
    Bracket.all.each do |bracket|
      test "bracket template #{validation} #{bracket.handle}" do
        assert BracketTemplateValidator.send(validation, bracket.template)
      end
    end
  end
end
