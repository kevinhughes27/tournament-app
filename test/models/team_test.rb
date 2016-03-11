require 'test_helper'

class TeamTest < ActiveSupport::TestCase
  setup do
    @team = teams(:swift)
    @game = games(:swift_goose)
  end

  test "deleting a team unassigns if from all games (home)" do
    assert_equal @team, @game.home
    @team.destroy
    assert_nil @game.reload.home
  end

  test "deleting a team unassigns if from all games (away)" do
    team = teams(:goose)
    assert_equal team, @game.away
    team.destroy
    assert_nil @game.reload.away
  end
end
