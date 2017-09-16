require "test_helper"

class AppBrowserTest < BrowserTestCase
  setup do
    @tournament = FactoryGirl.create(:tournament, handle: 'no-borders')
    @map = FactoryGirl.create(:map, tournament: @tournament)
    @team = FactoryGirl.create(:team, name: 'Swift')
    @game1 = FactoryGirl.create(:game, :scheduled, home: @team)
    @game2 = FactoryGirl.create(:game, :scheduled)
  end

  # test "submit a score" do
  #   visit("http://no-borders.#{Settings.domain}/")
  #   fill_in('')
  #
  #   click_on('Submit Score')
  #
  #   report = ScoreReport.last
  #   assert_equal 'Swift', report.team.name
  #   assert_equal @game1, report.game
  #   assert_equal 15, report.team_score
  #   assert_equal 11, report.opponent_score
  #   assert report.submitter_fingerprint
  # end
end
