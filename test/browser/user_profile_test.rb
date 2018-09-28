require 'test_helper'

class UserProfileBrowserTest < BrowserTest
  setup do
    @tournament = FactoryBot.create(:tournament, handle: 'no-borders')
    @user = FactoryBot.create(:user)
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)

    @team = FactoryBot.create(:team, name: 'Swift')
  end

  test 'admin next' do
    visit_app
    login
    navigate_to_profile
    change_password
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

  def navigate_to_profile
    find('#user-menu').click
    click_on('Profile')
  end

  def change_password
    assert_text 'Confirm Password'

    fill_in('password', with: 'password')
    fill_in('password_confirmation', with: 'password')

    click_save
    assert_text('Password changed')
  end

  def click_save
    find('button[type="submit"]').click
  end

  def logout
    find('#user-menu').click
    click_text('Logout')
    assert_text 'Log in to manage your tournament'
  end

  def click_text(text)
    page.find(:xpath,"//*[text()='#{text}']").click
  end
end
