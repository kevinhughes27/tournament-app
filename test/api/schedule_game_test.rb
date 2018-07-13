require 'test_helper'

class ScheduleGameTest < ApiTest
  setup do
    login_user
    @free_field = FactoryBot.create(:field)
    @output = '{ success message }'
  end

  test "checks for home team time conflicts" do
    game = FactoryBot.create(:game, :scheduled)
    new_game = FactoryBot.create(:game, home_prereq: game.home_prereq)

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
    game = FactoryBot.create(:game, :scheduled)
    new_game = FactoryBot.create(:game, away_prereq: game.home_prereq)

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
    game = FactoryBot.create(:game, :scheduled, home: nil)
    new_game = FactoryBot.create(:game, home_prereq: game.home_prereq)

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
    game = FactoryBot.create(:game, :scheduled)
    new_game = FactoryBot.create(:game, away_prereq: game.away_prereq)

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
    game = FactoryBot.create(:game, :scheduled)
    new_game = FactoryBot.create(:game, home_prereq: game.away_prereq)

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
    game = FactoryBot.create(:game, :scheduled, away: nil)
    new_game = FactoryBot.create(:game, away_prereq: game.away_prereq)

    input = {
      game_id: new_game.id,
      field_id: @free_field.id,
      start_time: game.start_time,
      end_time: game.end_time
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_failure "Team #{game.away_prereq} is already playing at 12:06 PM -  1:36 PM"
  end

  test "checks for team time conflicts (start_time)" do
    game = FactoryBot.create(:game, :scheduled)
    new_game = FactoryBot.create(:game, home_prereq: game.home_prereq)

    input = {
      game_id: new_game.id,
      field_id: @free_field.id,
      start_time: game.start_time - 60.minutes,
      end_time: game.end_time - 60.minutes
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_failure "Team #{game.home_prereq} is already playing at 12:06 PM -  1:36 PM"
  end

  test "checks for team time conflicts (end_time)" do
    game = FactoryBot.create(:game, :scheduled)
    new_game = FactoryBot.create(:game, home_prereq: game.home_prereq)

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
    game = FactoryBot.create(:game, :scheduled, away: nil)
    new_game = FactoryBot.create(:game, home_prereq: game.home_prereq, division: FactoryBot.create(:division))

    input = {
      game_id: new_game.id,
      field_id: @free_field.id,
      start_time: game.start_time,
      end_time: game.end_time
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_success
  end

  test "checks for field conflicts (exact overlap)" do
    game = FactoryBot.create(:game, :scheduled, away: nil)
    new_game = FactoryBot.create(:game, field: game.field, start_time: game.start_time, end_time: game.end_time)

    input = {
      game_id: new_game.id,
      field_id: game.field_id,
      start_time: game.start_time,
      end_time: game.end_time
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_failure "Field #{game.field.name} is in use at 12:06 PM -  1:36 PM"
  end

  test "checks for field conflicts (start_time)" do
    game = FactoryBot.create(:game, :scheduled, away: nil)
    new_game = FactoryBot.create(:game, field: game.field, start_time: game.start_time, end_time: game.end_time)

    input = {
      game_id: new_game.id,
      field_id: game.field_id,
      start_time: game.start_time - 30.minutes,
      end_time: game.end_time - 30.minutes
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_failure "Field #{game.field.name} is in use at 11:36 AM -  1:06 PM"
  end

  test "checks for field conflicts (end_time)" do
    game = FactoryBot.create(:game, :scheduled, away: nil)
    new_game = FactoryBot.create(:game, field: game.field, start_time: game.start_time, end_time: game.end_time)

    input = {
      game_id: new_game.id,
      field_id: game.field_id,
      start_time: game.start_time + 30.minutes,
      end_time: game.end_time + 30.minutes
    }

    execute_graphql("scheduleGame", "ScheduleGameInput", input, @output)
    assert_failure "Field #{game.field.name} is in use at 12:36 PM -  2:06 PM"
  end

  test "field conflict check immediately following" do
    game = FactoryBot.create(:game, :scheduled, away: nil)
    new_game = FactoryBot.create(:game)
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
    game1 = FactoryBot.create(:game, bracket_uid: 'a')
    game2 = FactoryBot.create(:game, :scheduled, bracket_uid: 'c', home_prereq: 'Wa', away_prereq: 'Wb')

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
    game1 = FactoryBot.create(:game, :scheduled, bracket_uid: 'a')
    game2 = FactoryBot.create(:game, bracket_uid: 'c', home_prereq: 'Wa', away_prereq: 'Wb')

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
