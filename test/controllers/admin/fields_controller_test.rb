require 'test_helper'

class Admin::FieldsControllerTest < AdminControllerTestCase
  test "get new" do
    FactoryGirl.create(:map)
    get :new
    assert_response :success
  end

  test "get show" do
    FactoryGirl.create(:map)
    field = FactoryGirl.create(:field)
    get :show, params: { id: field.id }
    assert_response :success
    assert_not_nil assigns(:field)
  end

  test "get index" do
    field = FactoryGirl.create(:field)
    get :index
    assert_response :success
    assert_not_nil assigns(:fields)
  end

  test "blank slate" do
    get :index
    assert_response :success
    assert_match 'blank-slate', response.body
  end

  test "get export_csv" do
    field = FactoryGirl.create(:field)
    get :export_csv, format: :csv
    assert_response :success
    assert_not_nil assigns(:fields)
    assert_equal "text/csv", response.content_type
  end

  test "create a field" do
    assert_difference "Field.count" do
      post :create, params: { field: field_params }

      field = assigns(:field)
      assert_redirected_to admin_field_path(field)
    end
  end

  test "create a field error re-renders form" do
    params = field_params
    params.delete(:name)

    assert_no_difference "Field.count" do
      post :create, params: { field: params }
      assert_template :new
    end
  end

  test "update a field" do
    field = FactoryGirl.create(:field)
    put :update, params: { id: field.id, field: field_params }

    assert_redirected_to admin_field_path(field)
    assert_equal field_params[:name], field.reload.name
  end

  test "update a field with errors" do
    field = FactoryGirl.create(:field)
    params = field_params
    params.delete(:name)

    put :update, params: { id: field.id, field: params }

    assert_redirected_to admin_field_path(field)
    refute_equal field_params[:name], field.reload.name
  end

  test "delete a field" do
    field = FactoryGirl.create(:field)

    assert_difference "Field.count", -1 do
      delete :destroy, params: { id: field.id }
      assert_redirected_to admin_fields_path
    end
  end

  test "delete a field needs confirm" do
    field = FactoryGirl.create(:field)
    FactoryGirl.create(:scheduled_game, field: field)

    assert_no_difference "Field.count" do
      delete :destroy, params: { id: field.id }
      assert_response :unprocessable_entity
      assert_template 'admin/fields/_confirm_delete'
    end
  end

  test "confirm delete a field" do
    field = FactoryGirl.create(:field)
    FactoryGirl.create(:scheduled_game, field: field)

    assert_difference "Field.count", -1 do
      delete :destroy, params: { id: field.id, confirm: 'true' }
      assert_redirected_to admin_fields_path
    end
  end

  test "sample_csv returns a csv download" do
    get :sample_csv, format: :csv
    assert_match 'Name,Latitude,Longitude,Geo JSON', response.body
  end

  test "import csv" do
    assert_difference "Field.count", +15 do
      post :import_csv, params: {
        csv_file: fixture_file_upload('files/fields.csv','text/csv'),
        match_behaviour: 'ignore'
      }
      assert_redirected_to admin_fields_path
      assert_equal 'Fields imported successfully', flash[:notice]
    end
  end

  test "import csv (ignore matches)" do
    assert_difference "Field.count", +15 do
      post :import_csv, params: {
        csv_file: fixture_file_upload('files/fields.csv','text/csv'),
        match_behaviour: 'ignore'
      }
      assert_redirected_to admin_fields_path
      assert_equal 'Fields imported successfully', flash[:notice]
    end

    assert_no_difference "Field.count" do
      post :import_csv, params: {
        csv_file: fixture_file_upload('files/fields.csv','text/csv'),
        match_behaviour: 'ignore'
      }
      assert_redirected_to admin_fields_path
      assert_equal 'Fields imported successfully', flash[:notice]
    end
  end

  test "import csv (update matches)" do
    field = FactoryGirl.create(:field, name: 'UPI5')

    assert_difference "Field.count", +14 do
      post :import_csv, params: {
        csv_file: fixture_file_upload('files/fields.csv','text/csv'),
        match_behaviour: 'update'
      }
      assert_redirected_to admin_fields_path
      assert_equal 'Fields imported successfully', flash[:notice]
    end
  end

  test "import csv with extra headings" do
    assert_difference "Field.count", +15 do
      post :import_csv, params: {
        csv_file: fixture_file_upload('files/fields-extra.csv','text/csv'),
        match_behaviour: 'ignore'
      }
      assert_redirected_to admin_fields_path
      assert_equal 'Fields imported successfully', flash[:notice]
    end
  end

  test "import csv with bad row data" do
    assert_no_difference "Field.count" do
      post :import_csv, params: {
        csv_file: fixture_file_upload('files/fields-bad-row.csv','text/csv'),
        match_behaviour: 'ignore'
      }
      assert_redirected_to admin_fields_path
      assert_equal "Row: 7 Validation failed: Name can't be blank", flash[:import_error]
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
