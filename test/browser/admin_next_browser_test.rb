require "test_helper"

class AdminNextBrowserTest < BrowserTest
  setup do
    @tournament = FactoryBot.create(:tournament, handle: 'no-borders')
    @user = FactoryBot.create(:user)
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)

    @team = FactoryBot.create(:team, name: 'Swift')
  end

  test 'admin next' do
    visit_app

    login

    assert_text 'Home'

    navigate_to('Teams')
    assert_text @team.name

    # navigate to team
    click_text(@team.name)
    assert_text @team.email

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
  end

  def navigate_to(nav_item)
    find('#side-bar').click
    click_on(nav_item)
  end

  def logout
    username = 'Kevin Hughes'
    find("img[alt='#{username}']").click
    click_text('Logout')
    assert_text 'Log in to manage your tournament'
  end

  def click_text(text)
    page.find(:xpath,"//*[text()='#{text}']").click
  end
end
