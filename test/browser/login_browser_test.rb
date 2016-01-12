require "test_helper"

class LoginBrowserTest < ActionDispatch::IntegrationTest
  include Capybara::DSL
  self.use_transactional_fixtures = false

  setup do
    @user = users(:kevin)
    @tournament = tournaments(:noborders)
    reset!
  end

  test "login to tournament admin" do
    visit("/#{@tournament.handle}/admin")

    fill_in('user_email', with: @user.email)
    fill_in('user_password', with: 'password')
    click_on('Log in')

    assert_match /#{@tournament.handle}\/admin/, current_url
  end

  test "login from signup page (no tournament info before login form)" do
    visit("/")
    click_on('Log in')

    fill_in('tournament', with: @tournament.handle)
    fill_in('user_email', with: @user.email)
    fill_in('user_password', with: 'password')
    click_on('Log in')

    assert_match /#{@tournament.handle}\/admin/, current_url
  end
end
