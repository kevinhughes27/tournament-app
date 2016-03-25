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
    params = {ids: ['1','2','3'], arg: 'beans'}
    BulkActions::TestJob.expects(:perform_now).with(params)
    put :perform, params.merge(job: 'test')
  end

  test "with missing job" do
    assert_raises Admin::BulkActionsController::MissingActionError do
      put :perform, {job: 'missing'}
    end
  end
end
