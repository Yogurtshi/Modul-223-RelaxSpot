require "test_helper"

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_users_index_url
    assert_response :success
  end

  test "should get show" do
    get admin_users_show_url
    assert_response :success
  end

  test "should get promote" do
    get admin_users_promote_url
    assert_response :success
  end

  test "should get demote" do
    get admin_users_demote_url
    assert_response :success
  end

  test "should get lock" do
    get admin_users_lock_url
    assert_response :success
  end

  test "should get unlock" do
    get admin_users_unlock_url
    assert_response :success
  end
end
