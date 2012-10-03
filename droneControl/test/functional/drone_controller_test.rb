require 'test_helper'

class DroneControllerTest < ActionController::TestCase
  test "should get new" do
    get :new
    assert_response :success
  end

  test "should get send_request" do
    get :send_request
    assert_response :success
  end

end
