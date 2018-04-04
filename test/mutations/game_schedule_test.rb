require 'test_helper'

class GameScheduleTest < ActiveSupport::TestCase
  setup do
    @tournament = FactoryGirl.create(:tournament)
    @division = FactoryGirl.create(:division)
    @free_field = FactoryGirl.create(:field)
  end

  test "checks for home team time conflicts" do
    game = FactoryGirl.create(:game, :scheduled)
    new_game = FactoryGirl.create(:game, home_prereq: game.home_prereq)

    schedule = GameSchedule.new(new_game, @free_field.id, game.start_time, game.end_time)

    error = assert_raises do
      schedule.perform
    end

    assert_equal "Team #{game.home_prereq} is already playing at 12:06 PM -  1:36 PM", error.message
  end

  test "finds home team time conflicts in games when the team is the away team in another game" do
    game = FactoryGirl.create(:game, :scheduled)
    new_game = FactoryGirl.create(:game, away_prereq: game.home_prereq)

    schedule = GameSchedule.new(new_game, @free_field.id, game.start_time, game.end_time)

    error = assert_raises do
      schedule.perform
    end

    assert_equal "Team #{game.home_prereq} is already playing at 12:06 PM -  1:36 PM", error.message
  end

  test "checks for home team time conflicts (uses uid if required)" do
    game = FactoryGirl.create(:game, :scheduled, home: nil)
    new_game = FactoryGirl.create(:game, home_prereq: game.home_prereq)

    schedule = GameSchedule.new(new_game, @free_field.id, game.start_time, game.end_time)

    error = assert_raises do
      schedule.perform
    end

    assert_equal "Team #{game.home_prereq} is already playing at 12:06 PM -  1:36 PM", error.message
  end

  test "checks for away team time conflicts" do
    game = FactoryGirl.create(:game, :scheduled)
    new_game = FactoryGirl.create(:game, away_prereq: game.away_prereq)

    schedule = GameSchedule.new(new_game, @free_field.id, game.start_time, game.end_time)

    error = assert_raises do
      schedule.perform
    end

    assert_equal "Team #{game.away_prereq} is already playing at 12:06 PM -  1:36 PM", error.message
  end

  test "finds away team time conflicts when the team is the home team in another game" do
    game = FactoryGirl.create(:game, :scheduled)
    new_game = FactoryGirl.create(:game, home_prereq: game.away_prereq)

    schedule = GameSchedule.new(new_game, @free_field.id, game.start_time, game.end_time)

    error = assert_raises do
      schedule.perform
    end

    assert_equal "Team #{game.away_prereq} is already playing at 12:06 PM -  1:36 PM", error.message
  end

  test "checks for away team time conflicts (uses uid if required)" do
    game = FactoryGirl.create(:game, :scheduled, away: nil)
    new_game = FactoryGirl.create(:game, away_prereq: game.away_prereq)

    schedule = GameSchedule.new(new_game, @free_field.id, game.start_time, game.end_time)

    error = assert_raises do
      schedule.perform
    end

    assert_equal "Team #{game.away_prereq} is already playing at 12:06 PM -  1:36 PM", error.message
  end

  test "team time conflicts must be same division" do
    game = FactoryGirl.create(:game, :scheduled, away: nil)
    new_game = FactoryGirl.create(:game, home_prereq: game.home_prereq, division: FactoryGirl.create(:division))

    schedule = GameSchedule.new(new_game, @free_field.id, game.start_time, game.end_time)
    schedule.perform
  end

  test "checks for field conflicts" do
    game = FactoryGirl.create(:game, :scheduled, away: nil)
    new_game = FactoryGirl.create(:game, field: game.field, start_time: game.start_time, end_time: game.end_time)

    schedule = GameSchedule.new(new_game, game.field_id, game.start_time, game.end_time)

    error = assert_raises do
      schedule.perform
    end

    assert_equal "Field #{game.field.name} is in use at 12:06 PM -  1:36 PM", error.message
  end

  test "field conflict check works with timecap increments" do
    game = FactoryGirl.create(:game, :scheduled, away: nil)
    new_game = FactoryGirl.create(:game)
    start_time = game.end_time

    schedule = GameSchedule.new(new_game, game.field_id, start_time, start_time + 90.minutes)
    schedule.perform

    assert schedule.succeeded?
  end

  test "games checks for schedule order conflicts (dependent game)" do
    game1 = FactoryGirl.create(:game, bracket_uid: 'a')
    game2 = FactoryGirl.create(:game, :scheduled, bracket_uid: 'c', home_prereq: 'Wa', away_prereq: 'Wb')

    schedule = GameSchedule.new(game1, @free_field.id, game2.start_time, game2.end_time)

    error = assert_raises do
      schedule.perform
    end

    assert_equal "Game '#{game1.bracket_uid}' must be played before game '#{game2.bracket_uid}'", error.message
  end

  test "games checks for schedule order conflicts (prerequisite game)" do
    game1 = FactoryGirl.create(:game, :scheduled, bracket_uid: 'a')
    game2 = FactoryGirl.create(:game, bracket_uid: 'c', home_prereq: 'Wa', away_prereq: 'Wb')

    schedule = GameSchedule.new(game2, @free_field.id, game1.start_time, game1.end_time)

    error = assert_raises do
      schedule.perform
    end

    assert_equal "Game '#{game2.bracket_uid}' must be played after game '#{game1.bracket_uid}'", error.message
  end
end