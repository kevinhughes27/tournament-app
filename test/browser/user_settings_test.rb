require 'test_helper'

class SettingsBrowserTest < BrowserTest
  setup do
    @tournament = FactoryBot.create(:tournament, handle: 'no-borders')
    @user = FactoryBot.create(:user)
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)
  end

  test 'admin next' do
    visit_app
    login
    navigate_to_settings
    edit_settings
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

  def navigate_to_settings
    find('#user-menu').click
    click_text('Settings')
  end

  def edit_settings
    fill_in('name', with: 'no-borders')
    fill_in('handle', with: 'no-borders')
    fill_in('scoreSubmitPin', with: '1111')
    click_save
    assert_text('Settings updated')
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
