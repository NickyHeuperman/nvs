require 'test_helper'

class KillboardControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get kill" do
    get :kill
    assert_response :success
  end

end
