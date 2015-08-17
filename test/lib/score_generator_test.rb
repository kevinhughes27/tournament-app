require 'test_helper'

class ScoreGeneratorTest < ActiveSupport::TestCase

  test "returns a non tie score" do
    score = ScoreGenerator.new.score
    assert score[0] != score[1]
  end

end
