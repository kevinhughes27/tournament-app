require 'test_helper'

class GameTest < ActiveSupport::TestCase
  test "one_team_present? is true if home or away is present" do
    game = FactoryGirl.build(:game)

    assert game.teams_present?
    assert game.one_team_present?

    game.home = nil
    assert game.one_team_present?

    game.away = nil
    refute game.one_team_present?
  end

  test "teams_present? is true if both teams are present" do
    game = FactoryGirl.build(:game)

    assert game.teams_present?

    game.home = nil
    refute game.teams_present?

    game.away = nil
    refute game.teams_present?
  end

  test "bracket_uid must be unique per division" do
    division = FactoryGirl.create(:division)
    FactoryGirl.create(:game, division: division, bracket_uid: 'a')
    game = FactoryGirl.build(:game, division: division, bracket_uid: 'a')

    refute game.valid?
    assert_equal ['has already been taken'], game.errors[:bracket_uid]
  end

  test "game must have field if it has a start_time" do
    game = FactoryGirl.build(:game, start_time: Time.now)
    refute game.valid?
    assert_equal ["can't be blank"], game.errors[:field]
  end

  test "game must have start_time if it has a field" do
    field = FactoryGirl.build(:field)
    game = FactoryGirl.build(:game, field: field)
    refute game.valid?
    assert_equal ["can't be blank"], game.errors[:start_time]
  end

  test "can unassign a game from field and start_time" do
    field = FactoryGirl.create(:field)
    game = FactoryGirl.create(:game, field: field, start_time: Time.now)
    game.update(field: nil, start_time: nil)
    assert game.errors.empty?
  end

  test "game must have a valid field" do
    field = FactoryGirl.create(:field)
    game = FactoryGirl.create(:game, field: field, start_time: Time.now)
    game.update(field_id: 999, start_time: nil)
    assert_equal ["is invalid"], game.errors[:field]
  end

  test "winner returns the team with more points" do
    game = FactoryGirl.create(:game, home_score: 15, away_score: 11)
    assert_equal game.home, game.winner

    game = FactoryGirl.create(:game, home_score: 11, away_score: 15)
    assert_equal game.away, game.winner
  end

  test "loser returns the team with less points" do
    game = FactoryGirl.create(:game, home_score: 15, away_score: 11)
    assert_equal game.away, game.loser

    game = FactoryGirl.create(:game, home_score: 11, away_score: 15)
    assert_equal game.home, game.loser
  end

  test "scores must be posetive" do
    game = FactoryGirl.build(:game, home_score: -1, away_score: -1)
    refute game.valid?
    assert_equal ["must be greater than or equal to 0"], game.errors[:home_score]
    assert_equal ["must be greater than or equal to 0"], game.errors[:away_score]
  end

  test "when a game is destroyed its score reports are too" do
    game = FactoryGirl.create(:game)
    report = FactoryGirl.create(:score_report, game: game, team: game.home)

    assert_difference "ScoreReport.count", -1 do
      game.reload
      game.destroy
    end
  end
end
