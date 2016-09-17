require 'test_helper'

class DivisionCreateTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @division = divisions(:open)
  end

  test "division creates all required games" do
    type = 'single_elimination_4'
    assert_difference "Game.count", +4 do
      create_division(bracket_type: type)
    end
  end

  test "division creates all required places" do
    type = 'single_elimination_4'
    assert_difference "Place.count", +4 do
      create_division(bracket_type: type)
    end
  end
end
