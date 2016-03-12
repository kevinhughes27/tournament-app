require 'test_helper'

class AppControllerTest < ActionController::TestCase
  setup do
    @tournament = tournaments(:noborders)
    set_tournament(@tournament)
    @report = score_reports(:swift_goose)
  end

  test "get show" do
    get :show
    assert_response :success
  end

  test "get show for non existent tournament 404s" do
    set_tournament('wat')
    get :show
    assert_response :not_found
  end

  test "create score report" do
    params = @report.attributes.merge(
      submitter_fingerprint: 'some_fingerprint'
    )

    assert_difference "ScoreReport.count", +1 do
      post :score_submit, params, format: :json
    end
  end
end
