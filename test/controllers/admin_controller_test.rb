require 'test_helper'

class AdminControllerTest < ActionDispatch::IntegrationTest
  test "should get dashboard" do
    get admin_dashboard_url
    assert_response :success
  end

  test "should get restore" do
    get admin_restore_url
    assert_response :success
  end

  test "should get item" do
    get admin_item_url
    assert_response :success
  end

  test "should get user" do
    get admin_user_url
    assert_response :success
  end

  test "should get history" do
    get admin_history_url
    assert_response :success
  end

end
