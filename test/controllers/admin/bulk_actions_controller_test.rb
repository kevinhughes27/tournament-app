require 'test_helper'

class Admin::BulkActionsControllerTest < ActionController::TestCase
  class BulkActions::TestJob
    def perform_now(params)
    end
  end

  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    sign_in users(:kevin)
  end

  test "queues the bulk action job" do
    params = {tournament_id: @tournament.id, ids: ['1','2','3'], arg: 'beans'}
    BulkActions::TestJob.expects(:perform_now).with(params)
    put :perform, params: params.merge(job: 'test')
  end

  test "with missing job" do
    Rollbar.expects(:error) do |error|
      assert error.is_a?(Admin::BulkActionsController::MissingActionError)
    end

    put :perform, params: {job: 'missing'}
  end
end
