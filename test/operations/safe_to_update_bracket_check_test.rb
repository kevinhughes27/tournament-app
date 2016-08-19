require 'test_helper'

class SafeToUpdateBracketCheckTest < ActiveJob::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @division = divisions(:women)
    @game = games(:semi_final)
    @check = SafeToUpdateBracketCheck.new(@division)
  end

  test "update is safe if no games are scheduled or played" do
    @game.update_columns(field_id: nil)
    @check.perform
    assert @check.succeeded?
  end

  test "unsafe if games are scheduled" do
    assert @game.field_id
    @check.perform
    refute @check.succeeded?
    assert_match 'have been scheduled', @check.message
  end

  test "unsafe if games are played" do
    @game.update_columns(field_id: nil, score_confirmed: true)
    @check.perform
    refute @check.succeeded?
    assert_match 'have been scored', @check.message
  end
end
