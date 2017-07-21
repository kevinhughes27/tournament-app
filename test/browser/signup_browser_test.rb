require "test_helper"

class SignupBrowserTest < BrowserTestCase
  test "signup" do
    visit("http://www.#{Settings.domain}/")
    click_on('Get Started')

    fill_in('user_email', with: Faker::Internet.email)
    fill_in('user_password', with: 'password')
    find('input[name="commit"]').click

    assert_text 'Your tournament will be available at:'
    fill_in('tournament_name', with: 'Browser Test Tournament')
    click_on('Next')

    assert_text "What's the time cap for games?"
    fill_in('tournament_time_cap', with: '80')
    click_on('Next')

    assert_text 'Where is your tournament?'
    fill_in('placesSearch', with: 'Ottawa')
    wait_for_ajax
    click_on('Next')

    assert_match /\/admin/, current_url

    tournament = Tournament.last
    assert_equal 'Browser Test Tournament', tournament.name
    assert_equal 80, tournament.time_cap
    assert_equal 'Ottawa', tournament.location
  end
end
