require "test_helper"

class Admin::UserSessionControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_user_session_new_url
    assert_response :success
  end
end
