require 'test_helper'

class Admin::FieldsControllerTest < ActionController::TestCase

  setup do
    http_login('admin', 'nobo')
    @tournament = tournaments(:noborders)
    @field = fields(:upi1)
  end

  test "get new" do
    get :new, tournament_id: @tournament.id
    assert_response :success
  end

  test "get show" do
    get :show, id: @field.id, tournament_id: @tournament.id
    assert_response :success
    assert_not_nil assigns(:field)
  end

  test "get index" do
    get :index, tournament_id: @tournament.id
    assert_response :success
    assert_not_nil assigns(:fields)
  end

  test "get export_csv" do
    get :export_csv, tournament_id: @tournament.id, format: :csv
    assert_response :success
    assert_not_nil assigns(:fields)
    assert_equal "text/csv", response.content_type
  end

  test "create a field" do
    assert_difference "Field.count" do
      post :create, tournament_id: @tournament.id, field: field_params

      field = assigns(:field)
      assert_redirected_to tournament_admin_field_path(@tournament, field)
    end
  end

  test "create a field error re-renders form" do
    params = field_params
    params.delete(:name)

    assert_no_difference "Field.count" do
      post :create, tournament_id: @tournament.id, field: params
      assert_template :new
    end
  end

  test "update a field" do
    put :update, id: @field.id, tournament_id: @tournament.id, field: field_params

    assert_redirected_to tournament_admin_field_path(@tournament, @field)
    assert_equal field_params[:name], @field.reload.name
  end

  test "update a team with errors" do
    params = field_params
    params.delete(:name)

    put :update, id: @field.id, tournament_id: @tournament.id, field: params

    assert_redirected_to tournament_admin_field_path(@tournament, @field)
    refute_equal field_params[:name], @field.reload.name
  end

  test "delete a field" do
    assert_difference "Field.count", -1 do
      delete :destroy, id: @field.id, tournament_id: @tournament.id
      assert_redirected_to tournament_admin_fields_path(@tournament)
    end
  end

  test "sample_csv returns a csv download" do
    get :sample_csv, tournament_id: @tournament.id, format: :csv
    assert_match 'Name,Latitude,Longitude,Geo JSON', response.body
  end

  test "import csv" do
    assert_difference "Field.count", +15 do
      post :import_csv, tournament_id: @tournament.id,
        csv_file: fixture_file_upload('files/fields.csv','text/csv'),
        match_behaviour: 'ignore'
    end
  end

  test "import csv (ignore matches)" do
    assert_difference "Field.count", +15 do
      post :import_csv, tournament_id: @tournament.id,
        csv_file: fixture_file_upload('files/fields.csv','text/csv'),
        match_behaviour: 'ignore'
    end

    assert_no_difference "Field.count" do
      post :import_csv, tournament_id: @tournament.id,
        csv_file: fixture_file_upload('files/fields.csv','text/csv'),
        match_behaviour: 'ignore'
    end
  end

  test "import csv (update matches)" do
    @field.update_attributes(name: 'UPI5')

    assert_difference "Field.count", +14 do
      post :import_csv, tournament_id: @tournament.id,
        csv_file: fixture_file_upload('files/fields.csv','text/csv'),
        match_behaviour: 'update'
    end
  end

  test "import csv with extra headings" do
    assert_difference "Field.count", +15 do
      post :import_csv, tournament_id: @tournament.id,
        csv_file: fixture_file_upload('files/fields-extra.csv','text/csv'),
        match_behaviour: 'ignore'
    end
  end

  test "import csv with bad row data" do
    assert_no_difference "Field.count" do
      post :import_csv, tournament_id: @tournament.id,
        csv_file: fixture_file_upload('files/fields-bad-row.csv','text/csv'),
        match_behaviour: 'ignore'
      # assert that some sort of error is shown or flashed
    end
  end

  private

  def field_params
    {
      name: 'UPI7',
      lat: 45.2442971314328,
      long: -75.6138271093369
    }
  end

end
