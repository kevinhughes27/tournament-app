require 'test_helper'

class Admin::BulkActionsControllerTest < ActionController::TestCase
  class BulkActions::TestAction
    def perform(params)
    end
  end

  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    sign_in users(:kevin)
  end

  test "performs the bulk action" do
    params = {tournament_id: @tournament.id, ids: ['1','2','3'], arg: 'beans'}
    BulkActions::TestAction.expects(:perform_now).with(params)
    put :perform, params: params.merge(action_class: 'test_action')
  end

  test "with missing action" do
    Rollbar.expects(:error) do |error|
      assert error.is_a?(Admin::BulkActionsController::MissingActionError)
    end

    put :perform, params: {action_class: 'missing'}
  end
end
