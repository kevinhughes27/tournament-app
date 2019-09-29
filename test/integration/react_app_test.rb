require 'test_helper'

class ReactAppTestTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)
  end

  test "redirects main js chunk" do
    get "http://#{@tournament.handle}.lvh.me/static/js/main.12ac65e5.chunk.js"
    assert_match /static\/js\/main\..{8}\.chunk.js/, response.redirect_url
  end

  test "redirects runtime~main js file" do
    get "http://#{@tournament.handle}.lvh.me/static/js/runtime~main.12ac65e5.js"
    assert_match /static\/js\/runtime~main\..{8}\.js/, response.redirect_url
  end

  test "redirects main css chunk" do
    get "http://#{@tournament.handle}.lvh.me/static/css/main.8a9416e7.chunk.css"
    assert_match /static\/css\/main\..{8}\.chunk.css/, response.redirect_url
  end

  test "redirects numbered js chunk" do
    get "http://#{@tournament.handle}.lvh.me/static/js/2.3e2437be.chunk.js"
    assert_match /static\/js\/2\..{8}\.chunk.js/, response.redirect_url
  end

  # this happened after I updated some packages. Could look into why and how
  # chunks get numbered.
  test "redirects numbered js chunk if chunk number has changed" do
    get "http://#{@tournament.handle}.lvh.me/static/js/1.3e2437be.chunk.js"
    assert_match /static\/js\/2\..{8}\.chunk.js/, response.redirect_url
  end
end
