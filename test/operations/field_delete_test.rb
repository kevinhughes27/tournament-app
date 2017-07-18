require 'test_helper'

class FieldDeleteTest < ActiveSupport::TestCase
  test "deleting a field unschedules any games from that field" do
    field = FactoryGirl.create(:field)
    game = FactoryGirl.create(:scheduled_game, field: field)

    FieldDelete.perform(field, 'true')

    assert_nil game.reload.field
    assert_nil game.start_time
  end
end
