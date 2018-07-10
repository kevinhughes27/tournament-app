require 'test_helper'

class ReactAppTestTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)
  end

  test "request for old asset redirects" do
    get "http://#{@tournament.handle}.lvh.me/static/js/old.js"
    assert_match /static\/js\/main\..{8}\.js/, response.redirect_url
  end
end
