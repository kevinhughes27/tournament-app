require 'test_helper'

class Admin::SettingsControllerTest < ActionController::TestCase

  setup do
    @tournament = tournaments(:noborders)
    @user = users(:kevin)
    sign_in @user
  end

  test "get settings page" do
    get :show, tournament_id: @tournament.id
  end

  test "update settings" do
    params = @tournament.attributes.merge(name: 'Updated Name')
    put :update, tournament_id: @tournament.id, tournament: params
    assert_equal 'Settings saved.', flash[:notice]
    assert_equal 'Updated Name', @tournament.reload.name
  end

  test "update settings error" do
    params = @tournament.attributes.merge(name: '')
    put :update, tournament_id: @tournament.id, tournament: params
    assert_equal 'Error saving Settings.', flash[:error]
  end

end
