require 'test_helper'

class Admin::BulkActionsControllerTest < ActionController::TestCase
  class BulkActions::TestAction
    def initialize(args)
    end
  end

  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    sign_in users(:kevin)
  end

  test "performs the action" do
    params = {tournament_id: @tournament.id, ids: ['1','2','3'], arg: 'beans'}
    mock_action = stub(perform: true, status: 200, response: '')
    BulkActions::TestAction.expects(:new).with(params).returns(mock_action)

    put :perform, params: params.merge(action_class: 'test_action')
  end

  test "with missing action" do
    Rollbar.expects(:error) do |error|
      assert error.is_a?(Admin::BulkActionsController::MissingActionError)
    end

    put :perform, params: {action_class: 'missing'}
  end
end
