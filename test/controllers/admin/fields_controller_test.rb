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

  test "create a field" do
    assert_difference "Field.count" do
      post :create, tournament_id: @tournament.id, field: field_params
      assert_template :show
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
    assert_template :show
    assert_equal field_params[:name], @field.reload.name
  end

  test "update a team with errors" do
    params = field_params
    params.delete(:name)

    put :update, id: @field.id, tournament_id: @tournament.id, field: params
    assert_template :show
    refute_equal field_params[:name], @field.reload.name
  end

  test "delete a field" do
    assert_difference "Field.count", -1 do
      delete :destroy, id: @field.id, tournament_id: @tournament.id
      assert_redirected_to tournament_admin_fields_path
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
