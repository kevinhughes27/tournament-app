require 'test_helper'

module Divisions
  class SafeToUpdateBracketJobTest < ActiveJob::TestCase
    setup do
      @tournament = tournaments(:noborders)
      @division = divisions(:women)
      @game = games(:semi_final)
    end

    test "update is safe if no games are scheduled or played" do
      @game.update_columns(field_id: nil)
      safe, message = perform
      assert safe
    end

    test "unsafe if games are scheduled" do
      assert @game.field_id
      safe, message = perform
      refute safe
      assert_match 'have been scheduled', message
    end

    test "unsafe if games are played" do
      @game.update_columns(field_id: nil, score_confirmed: true)
      safe, message = perform
      refute safe
      assert_match 'have been scored', message
    end

    def perform
      SafeToUpdateBracketJob.perform_now(division: @division)
    end
  end
end
