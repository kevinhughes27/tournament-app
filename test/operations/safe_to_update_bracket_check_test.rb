require 'test_helper'

class SafeToUpdateBracketCheckTest < OperationTest
  test "update is safe if no games are scheduled or played" do
    division = FactoryBot.create(:game).division
    check = SafeToUpdateBracketCheck.new(division)
    check.perform
    assert check.succeeded?
  end

  test "unsafe if games are scheduled" do
    division = FactoryBot.create(:game, :scheduled).division
    check = SafeToUpdateBracketCheck.new(division)
    check.perform
    refute check.succeeded?
    assert_match 'have been scheduled', check.output
  end

  test "unsafe if games are played" do
    division = FactoryBot.create(:game, :finished).division
    check = SafeToUpdateBracketCheck.new(division)
    check.perform
    refute check.succeeded?
    assert_match 'have been scored', check.output
  end
end
