require "test_helper"

class AppBrowserTest < ActionDispatch::IntegrationTest

  setup do
    @tournament = tournaments(:noborders)
  end

  test "drawer is closed" do
    visit("/#{@tournament.handle}")
    refute page.find("#drawer")[:class].include?("active"), 'Drawer is open'
  end

  test "find opens the drawer" do
    visit("/#{@tournament.handle}")
    click_on('Find')
    assert page.find("#drawer")[:class].include?("active"), 'Drawer is not open'
  end

end
