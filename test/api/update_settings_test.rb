require 'test_helper'

class UpdateSettingsTest < ApiTest
  setup do
    login_user
    @output = '{ success confirm message userErrors { field message } }'
  end

  test "queries" do
    input = {name: 'Updated Name', handle: @tournament.handle}

    assert_queries(9) do
      execute_graphql("updateSettings", "UpdateSettingsInput", input, @output)
      assert_success
    end
  end

  test "update settings" do
    input = {name: 'Updated Name', handle: @tournament.handle}
    execute_graphql("updateSettings", "UpdateSettingsInput", input, @output)
    assert_success
    assert_equal 'Updated Name', @tournament.reload.name
  end

  test "update handle requires confirm" do
    input = {handle: 'new-handle'}
    execute_graphql("updateSettings", "UpdateSettingsInput", input, @output)
    assert_confirmation_required "Changing your handle will change the web url of your tournament. If you have distributed this link anywhere it will no longer work."
  end

  test "update handle with confirm" do
    input = {handle: 'new-handle', confirm: true}
    execute_graphql("updateSettings", "UpdateSettingsInput", input, @output)
    assert_success
    assert_equal input[:handle], @tournament.reload.handle
  end

  test "set pin code" do
    input = {name: 'Updated Name', handle: @tournament.handle, scoreSubmitPin: '1234'}
    execute_graphql("updateSettings", "UpdateSettingsInput", input, @output)
    assert_success
    assert_equal '1234', @tournament.reload.score_submit_pin
  end

  test "remove pin code" do
    input = {name: 'Updated Name', handle: @tournament.handle, scoreSubmitPin: ''}
    execute_graphql("updateSettings", "UpdateSettingsInput", input, @output)
    assert_success
    assert_equal '', @tournament.reload.score_submit_pin
  end

  test "update settings error" do
    input = {name: '', handle: @tournament.handle}
    execute_graphql("updateSettings", "UpdateSettingsInput", input, @output)
    assert_failure({'field' => 'name', 'message' => "can't be blank"})
  end
end
