require "test_helper"

class TeamsTest < AdminNextTestCase
  setup do
    @team = FactoryBot.create(:team, name: 'Swift')
  end

  test 'update team' do
    visit_app
    login
    navigate_to('Teams')
    open_team
    edit_team
    logout
  end

  private

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
    click_save
    assert_text ('Team updated')

    team = Team.last
    assert_equal 'Hug Machine', team.name
    assert_equal 1, team.seed
  end
end
