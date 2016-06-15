require 'test_helper'

class ProcessBracketDbDiffTaskTest < MaintenanceTaskTextCase
  # diff to update uids for finals to numbers to save letters
  # test "running task updates games" do
  #   tournament = tournaments(:noborders)
  #   division = divisions(:open)
  #
  #   # representative old data
  #   game = Game.create!(
  #     tournament: tournament,
  #     division: division,
  #     round: 3,
  #     bracket_uid: 'f1',
  #     home_prereq_uid: 'Ws1',
  #     away_prereq_uid: 'Ws2'
  #   )
  #
  #   subject.invoke
  #
  #   game.reload
  #   assert_equal '1', game.bracket_uid
  #   assert_equal 3, game.round
  # end
end
