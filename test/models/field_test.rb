require 'test_helper'

class FieldTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
  end

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

  test "limited number of fields per tournament" do
    stub_constant(Field, :LIMIT, 2) do
      field = @tournament.fields.build(name: 'new field')
      refute field.valid?
      assert_equal ['Maximum of 2 fields exceeded'], field.errors[:base]
    end
  end

  test "limit is define" do
    assert_equal 64, Field::LIMIT
  end
end
