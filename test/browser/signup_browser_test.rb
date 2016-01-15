require "test_helper"

class SignupBrowserTest < ActiveSupport::TestCase
  include Capybara::DSL
  self.use_transactional_fixtures = false

  setup do
    Capybara.reset_sessions!
  end

  test "signup" do
    visit('/')
    click_on('Get Started')

    fill_in('user_email', with: 'bob@bob.com')
    fill_in('user_password', with: 'password')
    find('input[name="commit"]').click

    wait_for_ajax
    fill_in('tournament_name', with: 'New Tournament')
    click_on('Next')

    fill_in('tournament_time_cap', with: '80')
    click_on('Next')

    # map stuff
    wait_for_ajax
    click_on('Next')

    assert_match /new-tournament\/admin/, current_url

    tournament = Tournament.last
    assert_equal 'New Tournament', tournament.name
    assert_equal 80, tournament.time_cap
    assert tournament.destroy()
  end
end
