require 'test_helper'

class GameTest < ActiveSupport::TestCase

  setup do
    @tournament = tournaments(:noborders)
    @bracket = brackets(:open)
    @home = teams(:swift)
    @away = teams(:goose)
  end

  test "game must have field if it has a start_time" do
    game = games(:swift_goose)
    game.update_attributes(field: nil)
    assert_equal ["can't be blank"], game.errors[:field]
  end

  test "game must have start_time if it has a field" do
    game = games(:swift_goose)
    game.update_attributes(start_time: nil)
    assert_equal ["can't be blank"], game.errors[:start_time]
  end

  test "can unassign a game from field and start_time" do
    game = games(:swift_goose)
    game.update_attributes(field: nil, start_time: nil)
    assert game.errors.empty?
  end

  test "valid_for_seed_round? returns true if both top and bottom are integers" do
    game = Game.new(bracket_top: 1, bracket_bottom: 8)
    assert game.valid_for_seed_round?
  end

  test "valid_for_seed_round? returns true if both top and bottom are integer string" do
    game = Game.new(bracket_top: 1, bracket_bottom: "8")
    assert game.valid_for_seed_round?
  end

  test "valid_for_seed_round? returns false if either top or bottom are not integers" do
    game = Game.new(bracket_top: 1, bracket_bottom: 'A1')
    refute game.valid_for_seed_round?

    game = Game.new(bracket_top: 'B1', bracket_bottom: 'A1')
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

  test "confirm_score updates the bracket" do
    game = games(:swift_goose)
    game.expects(:update_bracket).once
    game.confirm_score(15, 11)
  end

  test "confirm_score updates the teams wins and points_for" do
    game = games(:swift_goose)
    game.expects(:update_bracket).once
    game.confirm_score(15, 11)

    @home.reload
    @away.reload

    assert_equal 1, @home.wins
    assert_equal 0, @away.wins
    assert_equal 15, @home.points_for
    assert_equal 11, @away.points_for
  end

  test "game pushes its winner through the bracket when its score is confirmed" do
    game1 = Game.create(tournament: @tournament, bracket: @bracket, bracket_uid: 'q1', bracket_top: '1', bracket_bottom: '2', home: @home, away: @away)
    game2 = Game.create(tournament: @tournament, bracket: @bracket, bracket_uid: 'q1', bracket_top: 'wq1', bracket_bottom: 'wq2')

    game1.confirm_score(15, 11)

    assert_equal @home, game2.reload.home
  end

  test "game pushes its loser through the bracket when its score is confirmed" do
    game1 = Game.create(tournament: @tournament, bracket: @bracket, bracket_uid: 'q1', bracket_top: '1', bracket_bottom: '2', home: @home, away: @away)
    game2 = Game.create(tournament: @tournament, bracket: @bracket, bracket_uid: 'q1', bracket_top: 'lq2', bracket_bottom: 'lq1')

    game1.confirm_score(15, 11)

    assert_equal @away, game2.reload.away
  end

  test "update_score updates the teams wins and points_for" do
    game = Game.create(tournament: @tournament, bracket: @bracket, bracket_uid: 'q1', bracket_top: '1', bracket_bottom: '2', home: @home, away: @away)
    game.expects(:update_bracket).twice
    game.confirm_score(15, 11)
    game.update_score(14, 12)

    @home.reload
    @away.reload

    assert_equal 1, @home.wins
    assert_equal 0, @away.wins
    assert_equal 14, @home.points_for
    assert_equal 12, @away.points_for
  end

  test "update_score can flip the winner" do
    game = Game.create(tournament: @tournament, bracket: @bracket, bracket_uid: 'q1', bracket_top: '1', bracket_bottom: '2', home: @home, away: @away)
    game.expects(:update_bracket).twice
    game.confirm_score(15, 11)
    game.update_score(10, 13)

    @home.reload
    @away.reload

    assert_equal 0, @home.wins
    assert_equal 1, @away.wins
    assert_equal 10, @home.points_for
    assert_equal 13, @away.points_for
  end

  test "update_score updates the bracket if the winner is changed" do
    game1 = Game.create(tournament: @tournament, bracket: @bracket, bracket_uid: 'q1', bracket_top: '1', bracket_bottom: '2', home: @home, away: @away)
    game2 = Game.create(tournament: @tournament, bracket: @bracket, bracket_uid: 'q1', bracket_top: 'wq1', bracket_bottom: 'wq2')

    game1.confirm_score(15, 11)
    assert_equal @home, game2.reload.home

    game1.update_score(10, 13)
    assert_equal @away, game2.reload.home
  end

  test "when a game is destroyed its score reports are too" do
    game = games(:swift_goose)
    assert_equal 1, game.score_reports.count

    assert_difference "ScoreReport.count", -1 do
      game.destroy
    end
  end

end
