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
end
