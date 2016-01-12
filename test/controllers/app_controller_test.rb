require 'test_helper'

class AppControllerTest < ActionController::TestCase
  setup do
    @tournament = tournaments(:noborders)
    @report = score_reports(:swift_goose)
  end

  test "get show" do
    get :show, tournament_id: @tournament.id
    assert_response :success
  end

  test "create score report" do
    params = @report.attributes.merge(
      tournament_id: @tournament.id,
      submitter_fingerprint: 'some_fingerprint'
    )

    assert_difference "ScoreReport.count", +1 do
      post :score_submit, params, format: :json
    end
  end

end
