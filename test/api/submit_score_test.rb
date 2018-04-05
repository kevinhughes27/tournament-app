require 'test_helper'

class SubmitScoreTest < ApiTest
  setup do
    @game = FactoryGirl.create(:game)
  end

  test "success" do
    execute_graphql("submitScore", "SubmitScoreInput", input)
    assert_success
  end

  test "error" do
    @input = input.delete(:home_score)
    execute_graphql("submitScore", "SubmitScoreInput", @input)
    assert_error "Variable input of type SubmitScoreInput! was provided invalid value"
  end

  private

  def input
    {
      game_id: @game.id,
      team_id: @game.home.id,
      submitter_fingerprint: 'fingerprint',
      home_score: 15,
      away_score: 13,
      rules_knowledge: 3,
      fouls: 3,
      fairness: 3,
      attitude: 3,
      communication: 3,
      comments: 'comment'
    }
  end
end
