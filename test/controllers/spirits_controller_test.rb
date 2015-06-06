require 'test_helper'

class SpiritsControllerTest < ActionController::TestCase
  setup do
    @spirit = spirits(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:spirits)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create spirit" do
    assert_difference('Spirit.count') do
      post :create, spirit: { author_id: @spirit.author_id, comm: @spirit.comm, fair: @spirit.fair, foul: @spirit.foul, rule: @spirit.rule, subject_id: @spirit.subject_id, tude: @spirit.tude }
    end

    assert_redirected_to spirit_path(assigns(:spirit))
  end

  test "should show spirit" do
    get :show, id: @spirit
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @spirit
    assert_response :success
  end

  test "should update spirit" do
    patch :update, id: @spirit, spirit: { author_id: @spirit.author_id, comm: @spirit.comm, fair: @spirit.fair, foul: @spirit.foul, rule: @spirit.rule, subject_id: @spirit.subject_id, tude: @spirit.tude }
    assert_redirected_to spirit_path(assigns(:spirit))
  end

  test "should destroy spirit" do
    assert_difference('Spirit.count', -1) do
      delete :destroy, id: @spirit
    end

    assert_redirected_to spirits_path
  end
end
