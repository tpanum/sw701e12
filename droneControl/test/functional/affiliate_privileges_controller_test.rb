require 'test_helper'

class AffiliatePrivilegesControllerTest < ActionController::TestCase
  setup do
    @affiliate_privilege = affiliate_privileges(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:affiliate_privileges)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create affiliate_privilege" do
    assert_difference('AffiliatePrivilege.count') do
      post :create, affiliate_privilege: {  }
    end

    assert_redirected_to affiliate_privilege_path(assigns(:affiliate_privilege))
  end

  test "should show affiliate_privilege" do
    get :show, id: @affiliate_privilege
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @affiliate_privilege
    assert_response :success
  end

  test "should update affiliate_privilege" do
    put :update, id: @affiliate_privilege, affiliate_privilege: {  }
    assert_redirected_to affiliate_privilege_path(assigns(:affiliate_privilege))
  end

  test "should destroy affiliate_privilege" do
    assert_difference('AffiliatePrivilege.count', -1) do
      delete :destroy, id: @affiliate_privilege
    end

    assert_redirected_to affiliate_privileges_path
  end
end
