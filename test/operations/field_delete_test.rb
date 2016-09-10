require 'test_helper'

class FieldDeleteTest < ActiveSupport::TestCase
  test "deleting a field unschedules any games from that field" do
    field = fields(:upi1)
    game = games(:swift_goose)

    assert_equal field, game.field
    assert game.start_time

    FieldDelete.perform(field, 'true')

    assert_nil game.reload.field
    assert_nil game.start_time
  end
end
