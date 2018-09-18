require 'test_helper'

class SettingBrowserTest < BrowserTest
  setup do
    @tournament = FactoryBot.create(:tournament, handle: 'no-borders')
    @user = FactoryBot.create(:user)
  end

  test 'user change password' do
    visit_app
    login
    navigate_to('Profile')
    change_user_password
    logout
  end

  private

  def visit_app
    visit("http://#{@tournament.handle}.#{Settings.host}/admin_next")
  end

  def login
    assert_text 'Log in to manage your tournament'

    fill_in('email', with: @user.email)
    fill_in('password', with: 'password')
    click_on('Log in')

    assert_text('Home')
  end

  def navigate_to(nav_item)
    find('#user-menu').click
    click_on(nav_item)
  end

  def change_user_password
    fill_in('password', with: "12345678")
    fill_in('password_confirmation', with: "12345678")
    find('button[type="submit"]').click
    click_button 
    assert_text 'Password changed'
  end

  def logout
    find("img[alt='#{@user.email}']").click
    click_text('Logout')
    assert_text 'Log in to manage your tournament'
  end

end
