require "test_helper"

class MapTest < PlayerAppTest
  test 'view the map and upcoming game' do
    visit_app
    navigate_to_map
    assert_field_label
    search_for_team('Swift')
    assert_upcoming_game
  end

  private

  def navigate_to_map
    click_on('Map')
  end

  def assert_field_label
    assert_text(@game.field.name)
  end

  def assert_upcoming_game
    assert_text('Swift vs Goose')
    start_time = @game.start_time.strftime('%l:%M')
    assert_text("@#{start_time}")
  end
end
