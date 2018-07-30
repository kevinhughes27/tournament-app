require 'test_helper'

class BracketDbTest < ActiveSupport::TestCase
  BracketDb::StructureValidator.methods(false).each do |validation|
    next unless validation.to_s.include? 'validate_'
    BracketDb.all.each do |handle, bracket|
      test "bracket template #{validation} #{handle}" do
        assert BracketDb::StructureValidator.send(validation, bracket.template)
      end
    end
  end

  test "where query" do
    brackets = BracketDb.where(teams: 8, days: 2)
    brackets.each do |b|
      assert_equal b.teams, 8
      assert_equal b.days, 2
    end
  end

  test "find query" do
    bracket = BracketDb.find(handle: 'USAU 8.1')
    assert bracket.handle, 'USAU 8.1'
  end
end
