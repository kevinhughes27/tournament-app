require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "one_team_present? is true if home or away is present" do
    game = FactoryBot.build(:game)

    assert game.teams_present?
    assert game.one_team_present?

    game.home = nil
    assert game.one_team_present?

    game.away = nil
    refute game.one_team_present?
  end

  test "teams_present? is true if both teams are present" do
    game = FactoryBot.build(:game)

    assert game.teams_present?

    game.home = nil
    refute game.teams_present?

    game.away = nil
    refute game.teams_present?
  end

  test "bracket_uid must be unique per division" do
    division = FactoryBot.create(:division)
    FactoryBot.create(:game, division: division, bracket_uid: 'a')
    game = FactoryBot.build(:game, division: division, bracket_uid: 'a')

    refute game.valid?
    assert_equal ['has already been taken'], game.errors[:bracket_uid]
  end

  test "winner returns the team with more points" do
    game = FactoryBot.create(:game, home_score: 15, away_score: 11)
    assert_equal game.home, game.winner

    game = FactoryBot.create(:game, home_score: 11, away_score: 15)
    assert_equal game.away, game.winner
  end

  test "loser returns the team with less points" do
    game = FactoryBot.create(:game, home_score: 15, away_score: 11)
    assert_equal game.away, game.loser

    game = FactoryBot.create(:game, home_score: 11, away_score: 15)
    assert_equal game.home, game.loser
  end

  test "scores must be posetive" do
    game = FactoryBot.build(:game, home_score: -1, away_score: -1)
    refute game.valid?
    assert_equal ["must be greater than or equal to 0"], game.errors[:home_score]
    assert_equal ["must be greater than or equal to 0"], game.errors[:away_score]
  end

  test "when a game is destroyed its score reports are too" do
    game = FactoryBot.create(:game)
    report = FactoryBot.create(:score_report, game: game, team: game.home)

    assert_difference "ScoreReport.count", -1 do
      game.reload
      game.destroy
    end
  end
end
