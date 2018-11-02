require "test_helper"

class DivisionsTest < AdminNextTestCase
  test 'create and seed division' do
    visit_app
    login
    side_menu('Divisions')
    action_button
    create_division

    create_teams(@division, 11)

    click_on('Divisions')
    open_division
    action_menu('seed')
    seed_division
    logout
  end

  test 'edit division' do
    @division = FactoryBot.create(:division, name: 'Mixed')

    visit_app
    login
    side_menu('Divisions')
    open_division
    action_menu('edit')
    edit_division
    logout
  end

  private

  def create_division
    fill_in('name', with: 'Open')
    fill_in('numTeams', with: ' ')
    fill_in('numTeams', with: 11)
    assert_text('USAU 11.')

    assert_difference "Division.count" do
      submit
      assert_text ('Division created')
    end

    @division = Division.last
    assert_equal 'Open', @division.name
  end

  def create_teams(division, num)
    @teams = (1..num).map do |seed|
      FactoryBot.create(:team, division: division, seed: seed)
    end
  end

  def open_division
    assert_text @division.name
    click_text(@division.name)
    assert_text @division.bracket.name
  end

  def seed_division
    assert_text(@teams[0].name)
    click_on 'Seed'
    assert_text('Division seeded')
    @division.reload
    assert @division.seeded
  end

  def edit_division
    assert_text('Edit')
    fill_in('numTeams', with: ' ')
    fill_in('numTeams', with: 11)
    fill_in('numDays', with: ' ')
    fill_in('numDays', with: 2)
    assert_text('USAU 11.')
    submit
    assert_text ('Division updated')
  end
end
