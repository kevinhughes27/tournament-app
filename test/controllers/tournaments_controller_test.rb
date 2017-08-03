require 'test_helper'

class TournamentsControllerTest < ActionController::TestCase
  setup do
    @user = FactoryGirl.create(:user)
    sign_in @user
  end

  test "get new" do
    get :new
    assert_response :success
  end

  test "new requires current user" do
    sign_out @user
    get :new
    assert_redirected_to new_user_session_path
  end

  test "create a new tournament" do
    assert_difference "Tournament.count" do
      post :create, params: { tournament: FactoryGirl.attributes_for(:tournament) }
    end
  end

  test "create a new tournament creates a new TournamentUser" do
    assert_difference "TournamentUser.count" do
      post :create, params: { tournament: FactoryGirl.attributes_for(:tournament) }
    end
  end

  test "create a new tournament redirects to builder" do
    post :create, params: { tournament: FactoryGirl.attributes_for(:tournament) }
    tournament = assigns(:tournament)
    assert_redirected_to admin_url(tournament)
  end

  test "create with errors renders form again" do
    post :create, params: { tournament: {name: 'No Borders'} }
    assert_template :new
  end

  test "if create tournament user fails then create fails and is rolled back" do
    error = ActiveRecord::RecordInvalid.new(Tournament.new)
    TournamentUser.expects(:create!).raises(error)

    assert_no_difference "Tournament.count" do
      post :create, params: { tournament: FactoryGirl.attributes_for(:tournament) }
      assert_template :new
    end
  end
end
