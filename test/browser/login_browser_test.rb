require "test_helper"

class LoginBrowserTest < BrowserTestCase
  setup do
    @user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament, handle: 'no-borders')
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)
  end

  test "login to tournament admin" do
    visit("http://no-borders.#{Settings.host}/admin")

    assert_text 'Log in to manage your tournament'
    fill_in('user_email', with: @user.email)
    fill_in('user_password', with: 'password')
    click_on('Log in')

    assert_match /admin/, current_url
  end

  test "login from signup page" do
    visit("http://www.#{Settings.host}")
    click_on('Log in')

    assert_text 'Log in to manage your tournament'
    fill_in('user_email', with: @user.email)
    fill_in('user_password', with: 'password')
    click_on('Log in')

    assert_match /admin/, current_url
  end
end
