require 'test_helper'

class GameTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @division = divisions(:open)
    @home = teams(:swift)
    @away = teams(:goose)
    @game = games(:swift_goose)
  end

  test "name returns home vs away if teams_present" do
    assert_equal "#{@home.name} vs #{@away.name}", @game.name
  end

  test "name returns bracket pos name if teams aren't assigned yet" do
    game = Game.new(division: @division, home_prereq_uid: 1, away_prereq_uid: 8)
    assert_equal "Open  (1 vs 8)", game.name
  end

  test "teams_present? is true if home and away are set" do
    assert @game.teams_present?
    @game.update_attributes(home_id: nil)
    refute @game.teams_present?
  end

  test "game must have field if it has a start_time" do
    @game.update_attributes(field: nil)
    assert_equal ["can't be blank"], @game.errors[:field]
  end

  test "game must have start_time if it has a field" do
    @game.update_attributes(start_time: nil)
    assert_equal ["can't be blank"], @game.errors[:start_time]
  end

  test "can unassign a game from field and start_time" do
    @game.update_attributes(field: nil, start_time: nil)
    assert @game.errors.empty?
  end

  test "valid_for_seed_round? returns true if either top and bottom are integers" do
    game = Game.new(home_prereq_uid: 1, away_prereq_uid: 8)
    assert game.valid_for_seed_round?
  end

  test "valid_for_seed_round? returns true if both top and bottom are integer string" do
    game = Game.new(home_prereq_uid: 1, away_prereq_uid: "8")
    assert game.valid_for_seed_round?
  end

  test "valid_for_seed_round? returns false if both top or bottom are not integers" do
    game = Game.new(home_prereq_uid: 'B1', away_prereq_uid: 'A1')
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

  test "update_score updates the bracket" do
    @game.expects(:update_bracket).once
    @game.update_score(15, 11)
  end

  test "update_score confirms the game" do
    @game.stubs(:update_bracket)
    @game.update_score(15, 11)
    assert @game.confirmed?
  end

  test "can't update score unless teams" do
    game = games(:semi_final)
    refute game.teams_present?
    game.update_score(10, 5)
    assert_nil game.score
  end

  test "update_score sets the score if no previous score" do
    game = games(:swift_goose_no_score)
    game.expects(:set_score).once
    game.stubs(:update_bracket)
    game.update_score(15, 11)
  end

  test "update_score adjusts the score if game already has a score" do
    @game.expects(:adjust_score).once
    @game.stubs(:update_bracket)
    @game.update_score(14, 12)
  end

  test "update_score updates the bracket if the winner is changed" do
    game1 = Game.create(tournament: @tournament, division: @division, bracket_uid: 'q1', home_prereq_uid: '1', away_prereq_uid: '2', home: @home, away: @away)
    game2 = Game.create(tournament: @tournament, division: @division, bracket_uid: 'q1', home_prereq_uid: 'wq1', away_prereq_uid: 'wq2')

    game1.update_score(15, 11)
    assert_equal @home, game2.reload.home

    game1.update_score(10, 13)
    assert_equal @away, game2.reload.home
  end

  test "when a game is destroyed its score reports are too" do
    assert_equal 2, @game.score_reports.count

    assert_difference "ScoreReport.count", -2 do
      @game.destroy
    end
  end
end
