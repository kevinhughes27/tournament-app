require_relative 'browser_test'

class AdminTest < BrowserTest
  setup do
    @tournament = FactoryBot.create(:tournament, handle: 'no-borders')
    @user = FactoryBot.create(:user)
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)
  end

  protected

  def visit_app
    visit("http://#{@tournament.handle}.#{Settings.host}/admin")
  end

  def login
    assert_text 'Log in to manage your tournament'

    fill_in('email', with: @user.email)
    fill_in('password', with: 'password')
    click_on('Log in')

    assert_text('Plan')
  end

  def side_menu(item)
    find('#side-bar').click
    click_on(item)
  end

  def user_menu(item)
    find('#user-menu').click
    sleep(0.1)
    menu_item = page.find(:xpath,"//*[text()='#{item}']")
    page.driver.browser.action.move_to(menu_item.native).click.perform
  end

  def action_button
    find('#action-menu').click
  end

  def action_menu(action)
    button = find('#action-menu > button')
    wait_for_button(button)
    button.hover
    click_on(action)
  end

  def submit
    button = find('button[type="submit"]')
    wait_for_button(button)
    button.click
  end

  def logout
    user_menu('Logout')
    assert_text 'Log in to manage your tournament'
  end

  def click_text(text)
    page.find(:xpath,"//*[text()='#{text}']").click
  end

  private

  def wait_for_button(button)
    loop do
      break if button.visible?
      sleep(0.1)
    end

    sleep(0.1)
  end
end
