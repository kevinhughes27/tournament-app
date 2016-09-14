require 'test_helper'

class ScheduleGameTest < ActiveSupport::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @division = divisions(:open)
    @home = teams(:swift)
    @away = teams(:goose)
    @game = games(:swift_goose)
    @free_field = fields(:upi5)
    @range_string = "12:06 PM -  1:26 PM"
  end

  test "checks for home team time conflicts" do
    new_game = build_game(home_prereq: @game.home_prereq)

    schedule = ScheduleGame.new(new_game, @free_field.id, @game.start_time)
    schedule.perform

    assert schedule.failed?
    assert_equal "Team #{@game.home_prereq} is already playing at #{@range_string}", schedule.message
  end

  test "finds home team time conflicts in games when the team is the away team in another game" do
    new_game = build_game(away_prereq: @game.home_prereq)

    schedule = ScheduleGame.new(new_game, @free_field.id, @game.start_time)
    schedule.perform

    assert schedule.failed?
    assert_equal "Team #{@game.home_prereq} is already playing at #{@range_string}", schedule.message
  end

  test "checks for home team time conflicts (uses uid if required)" do
    @game.update_columns(home_id: nil)
    new_game = build_game(home_prereq: @game.home_prereq)

    schedule = ScheduleGame.new(new_game, @free_field.id, @game.start_time)
    schedule.perform

    assert schedule.failed?
    assert_equal "Team #{@game.home_prereq} is already playing at #{@range_string}", schedule.message
  end

  test "checks for away team time conflicts" do
    new_game = build_game(away_prereq: @game.away_prereq)

    schedule = ScheduleGame.new(new_game, @free_field.id, @game.start_time)
    schedule.perform

    assert schedule.failed?
    assert_equal "Team #{@game.away_prereq} is already playing at #{@range_string}", schedule.message
  end

  test "finds away team time conflicts when the team is the home team in another game" do
    new_game = build_game(home_prereq: @game.away_prereq)

    schedule = ScheduleGame.new(new_game, @free_field.id, @game.start_time)
    schedule.perform

    assert schedule.failed?
    assert_equal "Team #{@game.away_prereq} is already playing at #{@range_string}", schedule.message
  end

  test "checks for away team time conflicts (uses uid if required)" do
    @game.update_columns(away_id: nil)
    new_game = build_game(away_prereq: @game.away_prereq)

    schedule = ScheduleGame.new(new_game, @free_field.id, @game.start_time)
    schedule.perform

    assert schedule.failed?
    assert_equal "Team #{@game.away_prereq} is already playing at #{@range_string}", schedule.message
  end

  test "team time conflicts must be same division" do
    new_game = build_game(
      home_prereq: @game.home_prereq,
      division: divisions(:women)
    )

    schedule = ScheduleGame.new(new_game, @free_field.id, @game.start_time)
    schedule.perform

    refute_equal "Team #{@game.away_prereq} is already playing at #{@range_string}", schedule.message
  end

  test "checks for field conflicts" do
    new_game = build_game(
      field: @game.field,
      start_time: @game.start_time,
    )

    schedule = ScheduleGame.new(new_game, @game.field_id, @game.start_time)
    schedule.perform

    assert schedule.failed?
    assert_equal "Field #{@game.field.name} is in use at #{@range_string}", schedule.message
  end

  test "field conflict check works with timecap increments" do
    new_game = build_game
    start_time = @game.start_time + @tournament.time_cap.minutes

    schedule = ScheduleGame.new(new_game, @game.field_id, start_time)
    schedule.perform

    assert schedule.succeeded?
  end

  test "games checks for schedule order conflicts (dependent game)" do
    game = games(:semi_final)
    dependent_uid = game.home_prereq.gsub('W','')

    new_game = build_game(
      bracket_uid: dependent_uid,
      division: divisions(:women)
    )

    schedule = ScheduleGame.new(new_game, @free_field.id, game.start_time)
    schedule.perform

    assert schedule.failed?
    assert_equal "Game '#{dependent_uid}' must be played before game '#{game.bracket_uid}'", schedule.message
  end

  test "games checks for schedule order conflicts (prerequisite game)" do
    game = games(:semi_final)
    prerequisite_uid = "W#{game.bracket_uid}"

    new_game = build_game(
      home_prereq: prerequisite_uid,
      bracket_uid: 'k',
      division: divisions(:women)
    )

    schedule = ScheduleGame.new(new_game, @free_field.id, game.start_time)
    schedule.perform

    assert schedule.failed?
    assert_equal "Game 'k' must be played after game '#{game.bracket_uid}'", schedule.message
  end

  private

  def build_game(params = {})
    Game.new(params.reverse_merge(
      home_prereq: 1,
      away_prereq: 2,
      bracket_uid: 'a',
      round: 1,
      division: @division,
      tournament: @tournament,
      start_time: DateTime.now
    ))
  end
end
