require "test_helper"

class LoginTest < AdminTest
  test "login to tournament admin" do
    visit("http://no-borders.#{Settings.host}/admin")

    assert_text 'Log in to manage your tournament'
    fill_in('email', with: @user.email)
    fill_in('password', with: 'password')
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

  test "login from www then logout" do
    visit("http://www.#{Settings.host}")
    click_on('Log in')

    assert_text 'Log in to manage your tournament'
    fill_in('user_email', with: @user.email)
    fill_in('user_password', with: 'password')
    click_on('Log in')

    assert_match /admin/, current_url
    logout
  end

  test "login from signup page multiple tournaments" do
    tournament = FactoryBot.create(:tournament, name: 'Two', handle: 'two')
    FactoryBot.create(:tournament_user, user: @user, tournament: tournament)

    visit("http://www.#{Settings.host}")
    click_on('Log in')

    assert_text 'Log in to manage your tournament'
    fill_in('user_email', with: @user.email)
    fill_in('user_password', with: 'password')
    click_on('Log in')

    assert_text "Choose tournament:"
    click_on('Two')

    assert_match /admin/, current_url
  end

  test "login no tournaments (incomplete signup)" do
    @user = FactoryBot.create(:user)

    visit("http://www.#{Settings.host}")
    click_on('Log in')

    assert_text 'Log in to manage your tournament'
    fill_in('user_email', with: @user.email)
    fill_in('user_password', with: 'password')
    click_on('Log in')

    assert_match /setup/, current_url
  end
end
