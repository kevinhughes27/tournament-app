require "test_helper"

class AppBrowserTest < BrowserTest
  setup do
    @tournament = FactoryGirl.create(:tournament, handle: 'no-borders')
    @map = FactoryGirl.create(:map, tournament: @tournament)
    @team = FactoryGirl.create(:team, name: 'Swift')
    @opponent = FactoryGirl.create(:team, name: 'Goose')
    @game1 = FactoryGirl.create(:game, :scheduled, home: @team, away: @opponent)
  end

  test 'submit a score' do
    visit("http://no-borders.#{Settings.domain}/")

    # search for team
    fill_in(placeholder: 'Search Teams', with: 'Swift')

    # navigate to submit score screen
    click_on('Submit Score')

    # click on game to submit score
    click_on('Swift vs Goose')

    # fill out form
    fill_in('home_score', with: 15)
    fill_in('away_score', with: 11)
    click_on('Submit')

    assert_submitted

    report = ScoreReport.last
    assert_equal 'Swift', report.team.name
    assert_equal @game1, report.game
    assert_equal 15, report.home_score
    assert_equal 11, report.away_score
    assert report.submitter_fingerprint
  end

  def assert_submitted
    assert page.find("svg[color='green']")
  end
end
