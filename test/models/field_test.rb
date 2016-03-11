require 'test_helper'

class FieldTest < ActiveSupport::TestCase
  test "deleting a field unassigns any games from that field" do
    field = fields(:upi1)
    game = games(:swift_goose)
    assert_equal field, game.field

    field.destroy

    assert_nil game.reload.field
  end

  test "safe_to_delete? is true for field with no games" do
    field = fields(:upi4)
    assert field.safe_to_delete?
  end

  test "safe_to_delete? is false for field games" do
    field = fields(:upi1)
    refute field.safe_to_delete?
  end
end
