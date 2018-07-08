require "test_helper"

class PlayerAppBrowserTest < BrowserTest
  setup do
    @tournament = FactoryBot.create(:tournament, handle: 'no-borders')
    @map = FactoryBot.create(:map, tournament: @tournament)
    @team = FactoryBot.create(:team, name: 'Swift')
    @opponent = FactoryBot.create(:team, name: 'Goose')
    @game1 = FactoryBot.create(:game, :scheduled, home: @team, away: @opponent)
  end

  test 'submit a score' do
    visit("http://no-borders.#{Settings.host}/")

    # search for team
    fill_in(placeholder: 'Search Teams', with: 'Swift')

    # navigate to submit score screen
    click_on('Submit Score')

    # click on game to submit score
    click_on('Swift vs Goose')

    # fill out form
    fill_in('homeScore', with: 15)
    fill_in('awayScore', with: 11)
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
