require 'test_helper'

class BracketDbTest < ActiveSupport::TestCase

  test "types returns each type" do
    assert BracketDb.types.include? 'single_elimination_8'
    assert BracketDb.types.include? 'single_elimination_4'
  end

  test "templates returns a hash of each template" do
    types = BracketDb.templates.keys
    assert types.include? 'single_elimination_8'
    assert types.include? 'single_elimination_4'
  end

  test "[] loads the template" do
    template = BracketDb['single_elimination_8']
    assert_equal 8, template[:num_teams]
  end

end
