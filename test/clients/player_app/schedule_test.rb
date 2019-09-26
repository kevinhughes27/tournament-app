require "test_helper"

class ScheduleTest < PlayerAppTest
  setup do
    @other_game = FactoryBot.create(:game, :scheduled)
  end

  test 'view and search the schedule' do
    visit_app
    assert_all_games_shown
    search_for_team('Swift')
    assert_games_are_filtered
    assert_upcoming_game
  end

  private

  def assert_all_games_shown
    assert_text('Swift vs Goose')
    assert_text(other_game_name)
  end

  def assert_games_are_filtered
    assert_text('Swift vs Goose')
    assert_no_text(other_game_name)
  end

  def assert_upcoming_game
    assert_text('Swift vs Goose')

    start_time = @game.start_time.strftime('%A%l:%M %p')
    assert_text(start_time)

    assert_text(@game.field.name)
  end

  def other_game_name
    "#{@other_game.home_name} vs #{@other_game.away_name}"
  end
end
