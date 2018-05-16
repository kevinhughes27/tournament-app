require 'test_helper'

class AuthTest < ApiTest
  test "mutation with auth" do
    login_user
    game = FactoryGirl.create(:game, :scheduled)
    input = {"game_id" => game.id, "home_score" => 10, "away_score" => 5}
    execute_graphql("updateScore", "UpdateScoreInput", input)
    assert_success
  end

  test "mutation without auth" do
    game = FactoryGirl.create(:game, :scheduled)
    input = {"game_id" => game.id, "home_score" => 10, "away_score" => 5}
    execute_graphql("updateScore", "UpdateScoreInput", input,
      expect_error: "You need to sign in or sign up before continuing")
  end

  test "mutation with auth for wrong tournament" do
    login_user
    @tournament = FactoryGirl.create(:tournament)
    game = FactoryGirl.create(:game, :scheduled, tournament: @tournament)
    input = {"game_id" => game.id, "home_score" => 10, "away_score" => 5}
    execute_graphql("updateScore", "UpdateScoreInput", input,
      expect_error: "You are not a registered user for this tournament")
  end

  test "mutation without auth with filter" do
    game = FactoryGirl.create(:game, :scheduled)
    input = {"game_id" => game.id, "home_score" => 10, "away_score" => 5}
    execute_graphql("updateScore", "UpdateScoreInput", input, filter: true,
      expect_error: "Field 'updateScore' doesn't exist on type 'Mutation'")
  end
end
