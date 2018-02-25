require 'test_helper'

class UpdateBracketGamesTaskTest < MaintenanceTaskTextCase
  # add rounds to pool games
  # test "running task updates games" do
  #   tournament = tournaments(:noborders)
  #   division = divisions(:open)
  #   division.update_columns(bracket_type: 'USAU 8.1')
  #
  #   # representative old data
  #   game = Game.create!(
  #     tournament: tournament,
  #     division: division,
  #     round: nil,
  #     pool: 'A',
  #     home_prereq: '1',
  #     away_prereq: '6'
  #   )
  #
  #   subject.invoke
  #
  #   game.reload
  #   assert_equal 1, game.round
  # end
end
