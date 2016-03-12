require "test_helper"

class LoginBrowserTest < BrowserTest
  test "login to tournament admin" do
    visit("http://no-borders.#{@domain}/admin")

    fill_in('user_email', with: @user.email)
    fill_in('user_password', with: 'password')
    click_on('Log in')

    assert_match /admin/, current_url
  end

  test "login from signup page" do
    visit("http://#{@domain}/")
    click_on('Log in')

    fill_in('user_email', with: @user.email)
    fill_in('user_password', with: 'password')
    click_on('Log in')

    assert_match /admin/, current_url
  end
end
