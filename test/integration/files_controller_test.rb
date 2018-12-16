require 'test_helper'

class FilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
    host! "#{@tournament.handle}.#{Settings.host}"
  end

  test "404 for no user" do
    get "/fields.csv"
    assert_response :unauthorized
  end

  test "404 for non tournament user" do
    set_cookie
    get "/fields.csv"
    assert_response :unauthorized
  end

  test "fields.csv" do
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)
    set_cookie
    get "/fields.csv"
    assert_response :ok
  end

  test "score_reports.csv" do
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)
    set_cookie
    get "/score_reports.csv"
    assert_response :ok
  end

  test "schedule.pdf" do
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)
    set_cookie
    get "/schedule.pdf"
    assert_response :ok
  end

  private

  def set_cookie
    token = Knock::AuthToken.new(payload: { sub: @user.id }).token
    cookies['jwt'] = token
  end
end
