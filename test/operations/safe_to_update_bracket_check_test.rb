require 'test_helper'

class SafeToUpdateBracketCheckTest < ActiveJob::TestCase
  test "update is safe if no games are scheduled or played" do
    division = FactoryGirl.create(:game).division
    assert SafeToUpdateBracketCheck.perform(division)
  end

  test "unsafe if games are scheduled" do
    division = FactoryGirl.create(:game, :scheduled).division

    error = assert_raises do
      SafeToUpdateBracketCheck.perform(division)
    end

    assert_match 'have been scheduled', error.message
  end

  test "unsafe if games are played" do
    division = FactoryGirl.create(:game, :finished).division

    error = assert_raises do
      SafeToUpdateBracketCheck.perform(division)
    end

    assert_match 'have been scored', error.message
  end
end
