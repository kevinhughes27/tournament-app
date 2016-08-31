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

  test "name returns seed vs name if teams aren't assigned yet" do
    game = Game.new(division: @division, home_prereq: 1, away_prereq: 8)
    assert_equal "1 vs 8", game.name
  end

  test "name returns bracket pos name if teams aren't assigned yet" do
    game = Game.new(division: @division, bracket_uid: 'a', home_prereq: 1, away_prereq: 8)
    assert_equal "a (1 vs 8)", game.name
  end

  test "teams_present? is true if away is set" do
    assert @game.teams_present?
    @game.update(home_id: nil)
    assert @game.teams_present?
  end

  test "teams_present? is true if home is set" do
    assert @game.teams_present?
    @game.update(away_id: nil)
    assert @game.teams_present?
  end

  test "teams_present? is false if no teams" do
    assert @game.teams_present?
    @game.update(home_id: nil, away_id: nil)
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

  test "game checks for home team time conflicts" do
    new_game = Game.new(
      home_prereq: @game.home_prereq,
      start_time: @game.start_time,
      division: @division,
      tournament: @tournament
    )

    refute new_game.valid?
    assert_equal ["Team #{@game.home_prereq} is already playing at #{@game.playing_time_range_string}"], new_game.errors[:base]
  end

  test "game finds home team time conflicts in games when the team is the away team in another game" do
    new_game = Game.new(
      away_prereq: @game.home_prereq,
      start_time: @game.start_time,
      division: @division,
      tournament: @tournament
    )

    refute new_game.valid?
    assert_equal ["Team #{@game.home_prereq} is already playing at #{@game.playing_time_range_string}"], new_game.errors[:base]
  end

  test "game checks for home team time conflicts (uses uid if required)" do
    @game.update_columns(home_id: nil)
    new_game = Game.new(
      home_prereq: @game.home_prereq,
      start_time: @game.start_time,
      division: @division,
      tournament: @tournament
    )

    refute new_game.valid?
    assert_equal ["Team #{@game.home_prereq} is already playing at #{@game.playing_time_range_string}"], new_game.errors[:base]
  end

  test "game checks for away team time conflicts" do
    new_game = Game.new(
      away_prereq: @game.away_prereq,
      start_time: @game.start_time,
      division: @division,
      tournament: @tournament
    )

    refute new_game.valid?
    assert_equal ["Team #{@game.away_prereq} is already playing at #{@game.playing_time_range_string}"], new_game.errors[:base]
  end

  test "game finds away team time conflicts when the team is the home team in another game" do
    new_game = Game.new(
      home_prereq: @game.away_prereq,
      start_time: @game.start_time,
      division: @division,
      tournament: @tournament
    )

    refute new_game.valid?
    assert_equal ["Team #{@game.away_prereq} is already playing at #{@game.playing_time_range_string}"], new_game.errors[:base]
  end

  test "game checks for away team time conflicts (uses uid if required)" do
    @game.update_columns(away_id: nil)
    new_game = Game.new(
      away_prereq: @game.away_prereq,
      start_time: @game.start_time,
      division: @division,
      tournament: @tournament
    )

    refute new_game.valid?
    assert_equal ["Team #{@game.away_prereq} is already playing at #{@game.playing_time_range_string}"], new_game.errors[:base]
  end

  test "team time conflicts must be same division" do
    new_game = Game.new(
      home_prereq: @game.home_prereq,
      start_time: @game.start_time,
      division: divisions(:women),
      tournament: @tournament
    )

    refute_equal ["Team #{@game.away_prereq} is already playing at #{@game.playing_time_range_string}"], new_game.errors[:base]
  end

  test "game checks for field conflicts" do
    new_game = Game.new(
      field: @game.field,
      start_time:
      @game.start_time,
      tournament: @tournament
    )

    refute new_game.valid?
    assert_equal ["Field #{@game.field.name} is in use at #{@game.playing_time_range_string}"], new_game.errors[:base]
  end

  test "game field conflict check works with timecap increments" do
    new_game = Game.new(
      field: @game.field,
      start_time: @game.start_time + @tournament.time_cap.minutes,
      tournament: @tournament
    )

    refute_equal ["Field #{@game.field.name} is in use at #{@game.playing_time_range_string}"], new_game.errors[:base]
  end

  test "games checks for schedule order conflicts (dependent game)" do
    game = games(:semi_final)
    dependent_uid = game.home_prereq.gsub('W','')

    new_game = Game.new(
      bracket_uid: dependent_uid,
      start_time: game.start_time,
      division: divisions(:women),
      tournament: @tournament
    )

    refute new_game.valid?
    assert_equal ["Game '#{dependent_uid}' must be played before game '#{game.bracket_uid}'"], new_game.errors[:base]
  end

  test "games checks for schedule order conflicts (prerequisite game)" do
    game = games(:semi_final)
    prerequisite_uid = "W#{game.bracket_uid}"

    new_game = Game.new(
      home_prereq: prerequisite_uid,
      bracket_uid: 'k',
      start_time: game.start_time,
      division: divisions(:women),
      tournament: @tournament
    )

    refute new_game.valid?
    assert_equal ["Game 'k' must be played after game '#{game.bracket_uid}'"], new_game.errors[:base]
  end
end
