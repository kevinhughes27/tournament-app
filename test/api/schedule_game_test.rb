require 'test_helper'

class ScheduleGameTest < ApiTest
  setup do
    login_user
    @free_field = FactoryGirl.create(:field)
    @output = '{ success, errors }'
  end

  test "checks for home team time conflicts" do
    game = FactoryGirl.create(:game, :scheduled)
    new_game = FactoryGirl.create(:game, home_prereq: game.home_prereq)

    input = {
      game_id: new_game.id,
      field_id: @free_field.id,
      start_time: game.start_time,
      end_time: game.end_time
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_failure "Team #{game.home_prereq} is already playing at 12:06 PM -  1:36 PM"
  end

  test "finds home team time conflicts in games when the team is the away team in another game" do
    game = FactoryGirl.create(:game, :scheduled)
    new_game = FactoryGirl.create(:game, away_prereq: game.home_prereq)

    input = {
      game_id: new_game.id,
      field_id: @free_field.id,
      start_time: game.start_time,
      end_time: game.end_time
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_failure "Team #{game.home_prereq} is already playing at 12:06 PM -  1:36 PM"
  end

  test "checks for home team time conflicts (uses uid if required)" do
    game = FactoryGirl.create(:game, :scheduled, home: nil)
    new_game = FactoryGirl.create(:game, home_prereq: game.home_prereq)

    input = {
      game_id: new_game.id,
      field_id: @free_field.id,
      start_time: game.start_time,
      end_time: game.end_time
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_failure "Team #{game.home_prereq} is already playing at 12:06 PM -  1:36 PM"
  end

  test "checks for away team time conflicts" do
    game = FactoryGirl.create(:game, :scheduled)
    new_game = FactoryGirl.create(:game, away_prereq: game.away_prereq)

    input = {
      game_id: new_game.id,
      field_id: @free_field.id,
      start_time: game.start_time,
      end_time: game.end_time
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_failure "Team #{game.away_prereq} is already playing at 12:06 PM -  1:36 PM"
  end

  test "finds away team time conflicts when the team is the home team in another game" do
    game = FactoryGirl.create(:game, :scheduled)
    new_game = FactoryGirl.create(:game, home_prereq: game.away_prereq)

    input = {
      game_id: new_game.id,
      field_id: @free_field.id,
      start_time: game.start_time,
      end_time: game.end_time
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_failure "Team #{game.away_prereq} is already playing at 12:06 PM -  1:36 PM"
  end

  test "checks for away team time conflicts (uses uid if required)" do
    game = FactoryGirl.create(:game, :scheduled, away: nil)
    new_game = FactoryGirl.create(:game, away_prereq: game.away_prereq)

    input = {
      game_id: new_game.id,
      field_id: @free_field.id,
      start_time: game.start_time,
      end_time: game.end_time
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_failure "Team #{game.away_prereq} is already playing at 12:06 PM -  1:36 PM"
  end

  test "checks for overlap team time conflicts" do
    game = FactoryGirl.create(:game, :scheduled)
    new_game = FactoryGirl.create(:game, home_prereq: game.home_prereq)

    input = {
      game_id: new_game.id,
      field_id: @free_field.id,
      start_time: game.start_time - 60.minutes,
      end_time: game.end_time - 60.minutes
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_failure "Team #{game.home_prereq} is already playing at 12:06 PM -  1:36 PM"
  end

  test "checks for underlap team time conflicts" do
    game = FactoryGirl.create(:game, :scheduled)
    new_game = FactoryGirl.create(:game, home_prereq: game.home_prereq)

    input = {
      game_id: new_game.id,
      field_id: @free_field.id,
      start_time: game.start_time + 60.minutes,
      end_time: game.end_time + 60.minutes
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_failure "Team #{game.home_prereq} is already playing at 12:06 PM -  1:36 PM"
  end

  test "team time conflicts must be same division" do
    game = FactoryGirl.create(:game, :scheduled, away: nil)
    new_game = FactoryGirl.create(:game, home_prereq: game.home_prereq, division: FactoryGirl.create(:division))

    input = {
      game_id: new_game.id,
      field_id: @free_field.id,
      start_time: game.start_time,
      end_time: game.end_time
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_success
  end

  test "checks for field conflicts" do
    game = FactoryGirl.create(:game, :scheduled, away: nil)
    new_game = FactoryGirl.create(:game, field: game.field, start_time: game.start_time, end_time: game.end_time)

    input = {
      game_id: new_game.id,
      field_id: game.field_id,
      start_time: game.start_time,
      end_time: game.end_time
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_failure "Field #{game.field.name} is in use at 12:06 PM -  1:36 PM"
  end

  test "field conflict check works with timecap increments" do
    game = FactoryGirl.create(:game, :scheduled, away: nil)
    new_game = FactoryGirl.create(:game)
    start_time = game.end_time

    input = {
      game_id: new_game.id,
      field_id: game.field_id,
      start_time: start_time,
      end_time: start_time + 90.minutes
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_success
  end

  test "games checks for schedule order conflicts (dependent game)" do
    game1 = FactoryGirl.create(:game, bracket_uid: 'a')
    game2 = FactoryGirl.create(:game, :scheduled, bracket_uid: 'c', home_prereq: 'Wa', away_prereq: 'Wb')

    input = {
      game_id: game1.id,
      field_id: @free_field.id,
      start_time: game2.start_time,
      end_time: game2.end_time
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_failure "Game '#{game1.bracket_uid}' must be played before game '#{game2.bracket_uid}'"
  end

  test "games checks for schedule order conflicts (prerequisite game)" do
    game1 = FactoryGirl.create(:game, :scheduled, bracket_uid: 'a')
    game2 = FactoryGirl.create(:game, bracket_uid: 'c', home_prereq: 'Wa', away_prereq: 'Wb')

    input = {
      game_id: game2.id,
      field_id: @free_field.id,
      start_time: game1.start_time,
      end_time: game1.end_time
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_failure "Game '#{game2.bracket_uid}' must be played after game '#{game1.bracket_uid}'"
  end
end
