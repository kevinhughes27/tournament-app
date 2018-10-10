require_relative 'browser_test_case'

class AdminNextTestCase < BrowserTestCase
  setup do
    @tournament = FactoryBot.create(:tournament, handle: 'no-borders')
    @user = FactoryBot.create(:user)
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)
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

  def action_button
    find('#action-menu').click
  end

  def action_menu(action)
    find('body').native.send_key(:tab) # sidebar

    loop do
      find('body').native.send_key(:tab)

      begin
        click_on(action)
        break
      rescue
        next
      end
    end
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
