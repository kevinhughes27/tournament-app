require 'test_helper'

class AuthTest < ApiTest
  test "mutation with auth" do
    login_user
    game = FactoryBot.create(:game, :scheduled)
    input = {"game_id" => relay_id('Game', game.id), "home_score" => 10, "away_score" => 5}
    execute_graphql("updateScore", "UpdateScoreInput", input)
    assert_success
  end

  test "mutation with staff auth" do
    staff = FactoryBot.create(:staff)
    login_user(staff)
    game = FactoryBot.create(:game, :scheduled)
    input = {"game_id" => relay_id('Game', game.id), "home_score" => 10, "away_score" => 5}
    execute_graphql("updateScore", "UpdateScoreInput", input)
    assert_success
  end

  test "mutation without auth" do
    game = FactoryBot.create(:game, :scheduled)
    input = {"game_id" => relay_id('Game', game.id), "home_score" => 10, "away_score" => 5}
    execute_graphql("updateScore", "UpdateScoreInput", input,
      expect_error: "You need to sign in or sign up before continuing")
  end

  test "mutation with auth for wrong tournament" do
    login_user
    @tournament = FactoryBot.create(:tournament)
    game = FactoryBot.create(:game, :scheduled, tournament: @tournament)
    input = {"game_id" => relay_id('Game', game.id), "home_score" => 10, "away_score" => 5}
    execute_graphql("updateScore", "UpdateScoreInput", input,
      expect_error: "You are not a registered user for this tournament")
  end

  test "mutation without auth with filter" do
    game = FactoryBot.create(:game, :scheduled)
    input = {"game_id" => relay_id('Game', game.id), "home_score" => 10, "away_score" => 5}
    execute_graphql("updateScore", "UpdateScoreInput", input, filter: true,
      expect_error: "Field 'updateScore' doesn't exist on type 'Mutation'")
  end
end
