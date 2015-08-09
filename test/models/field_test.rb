require 'test_helper'

class FieldTest < ActiveSupport::TestCase
  test "deleting a field unassigns any games from that field" do
    field = fields(:upi1)
    game = games(:swift_goose)
    assert_equal field, game.field

    field.destroy

    assert_nil game.reload.field
  end
end
