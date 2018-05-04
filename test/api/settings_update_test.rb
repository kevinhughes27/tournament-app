require 'test_helper'

class SettingsUpdateTest < ApiTest
  setup do
    login_user
    @output = '{ success, confirm, errors }'
  end

  test "update settings" do
    input = {name: 'Updated Name', handle: @tournament.handle}
    execute_graphql("settingsUpdate", "SettingsUpdateInput", input, @output)
    assert_success
    assert_equal 'Updated Name', @tournament.reload.name
  end

  test "update handle requires confirm" do
    input = {handle: 'new-handle'}
    execute_graphql("settingsUpdate", "SettingsUpdateInput", input, @output)
    assert_confirmation_required "Changing your handle will change the web url of your tournament. If you have distributed this link anywhere it will no longer work."
  end

  test "update handle with confirm" do
    input = {handle: 'new-handle', confirm: true}
    execute_graphql("settingsUpdate", "SettingsUpdateInput", input, @output)
    assert_success
    assert_equal input[:handle], @tournament.reload.handle
  end

  test "update settings error" do
    input = {name: '', handle: @tournament.handle}
    execute_graphql("settingsUpdate", "SettingsUpdateInput", input, @output)
    assert_failure "Name can't be blank"
  end
end