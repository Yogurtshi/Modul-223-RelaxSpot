require "test_helper"

class Moderation::PlacesControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get moderation_places_show_url
    assert_response :success
  end

  test "should get edit" do
    get moderation_places_edit_url
    assert_response :success
  end

  test "should get update" do
    get moderation_places_update_url
    assert_response :success
  end

  test "should get approve" do
    get moderation_places_approve_url
    assert_response :success
  end

  test "should get reject" do
    get moderation_places_reject_url
    assert_response :success
  end

  test "should get unlock" do
    get moderation_places_unlock_url
    assert_response :success
  end
end
