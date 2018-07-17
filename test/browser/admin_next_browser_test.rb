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
    navigate_to('Teams')
    open_team
    edit_team
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
    find('#side-bar').click
    click_on(nav_item)
  end

  def open_team
    assert_text @team.name
    click_text(@team.name)
    assert_equal find_field('email').value, @team.email
  end

  def edit_team
    fill_in('name', with: '')
    fill_in('name', with: 'Hug Machine')
    fill_in('seed', with: '')
    fill_in('seed', with: 1)
    click_on('Save')
    assert_text ('Team updated')

    team = Team.last
    assert_equal 'Hug Machine', team.name
    assert_equal 1, team.seed
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
