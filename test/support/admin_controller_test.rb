class AdminControllerTest < ActionController::TestCase
  setup do
    @user = FactoryBot.create(:user)
    @tournament = FactoryBot.create(:tournament)
    FactoryBot.create(:tournament_user, user: @user, tournament: @tournament)
    set_tournament(@tournament)
    sign_in @user

    ReactOnRails::TestHelper.ensure_assets_compiled
  end
end
