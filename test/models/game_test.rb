require 'test_helper'

class GameTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @division = divisions(:open)
    @home = teams(:swift)
    @away = teams(:goose)
    @game = games(:swift_goose)
  end

  test "one_team_present? is true if home or away is present" do
    assert @game.one_team_present?

    @game.update(home_id: nil)
    assert @game.one_team_present?

    @game.update(away_id: nil)
    refute @game.one_team_present?
  end

  test "teams_present? is true if both teams are present" do
    assert @game.teams_present?

    @game.update(home_id: nil)
    refute @game.teams_present?

    @game.update(away_id: nil)
    refute @game.teams_present?
  end

  test "bracket_uid must be unique" do
    game = Game.new(division: @division, bracket_uid: @game.bracket_uid)
    refute game.valid?
    assert_equal ['has already been taken'], game.errors[:bracket_uid]
  end

  test "game must have field if it has a start_time" do
    @game.update(field: nil)
    assert_equal ["can't be blank"], @game.errors[:field]
  end

  test "game must have start_time if it has a field" do
    @game.update(start_time: nil)
    assert_equal ["can't be blank"], @game.errors[:start_time]
  end

  test "can unassign a game from field and start_time" do
    @game.update(field: nil, start_time: nil)
    assert @game.errors.empty?
  end

  test "game must have a valid field" do
    @game.update(field_id: 999, start_time: nil)
    assert_equal ["is invalid"], @game.errors[:field]
  end

  test "valid_for_seed_round? returns true if either top and bottom are integers" do
    game = Game.new(home_prereq: 1, away_prereq: 8)
    assert game.valid_for_seed_round?
  end

  test "valid_for_seed_round? returns true if both top and bottom are integer string" do
    game = Game.new(home_prereq: 1, away_prereq: "8")
    assert game.valid_for_seed_round?
  end

  test "valid_for_seed_round? returns false if both top or bottom are not integers" do
    game = Game.new(home_prereq: 'B1', away_prereq: 'A1')
    refute game.valid_for_seed_round?
  end

  test "winner returns the team with more points" do
    game = Game.new(home: @home, away: @away, home_score: 15, away_score: 11)
    assert_equal @home, game.winner

    game = Game.new(home: @home, away: @away, home_score: 11, away_score: 15)
    assert_equal @away, game.winner
  end

  test "loser returns the team with less points" do
    game = Game.new(home: @home, away: @away, home_score: 15, away_score: 11)
    assert_equal @away, game.loser

    game = Game.new(home: @home, away: @away, home_score: 11, away_score: 15)
    assert_equal @home, game.loser
  end

  test "scores must be posetive" do
    game = Game.new(home_score: -1, away_score: -1)
    refute game.valid?
    assert_equal ["must be greater than or equal to 0"], game.errors[:home_score]
    assert_equal ["must be greater than or equal to 0"], game.errors[:away_score]
  end

  test "when a game is destroyed its score reports are too" do
    assert_equal 2, @game.score_reports.count

    assert_difference "ScoreReport.count", -2 do
      @game.destroy
    end
  end
end
