require 'test_helper'

class SignupBrowserTest < BrowserTestCase
  test 'signup' do
    visit("http://www.#{Settings.domain}/")
    click_on('Get Started')

    fill_in('user_email', with: Faker::Internet.email)
    fill_in('user_password', with: 'password')
    find('input[name="commit"]').click

    # for animation
    sleep(1)

    assert_text 'Your tournament will be available at:'
    fill_in('tournament_name', with: 'Browser Test Tournament')
    click_on('Next')

    assert_text 'Browser Test Tournament'
    assert_match /\/admin/, current_url

    tournament = Tournament.last
    assert_equal 'Browser Test Tournament', tournament.name
  end
end
