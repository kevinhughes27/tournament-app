require 'test_helper'

module Fields
  class UnassignGamesJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @field = fields(:upi1)
      @game = games(:swift_goose)
    end

    test "unassigns all games from the field and removes start time" do
      assert_equal @field, @game.field

      UnassignGamesJob.perform_now(
        tournament_id: @tournament.id,
        field_id: @field.id
      )

      assert_nil @game.reload.field
      assert_nil @game.start_time
    end
  end
end
