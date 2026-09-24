require "test_helper"

class Moderation::PlacesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @moderator = User.create!(
      name: "Moderator User",
      email: "moderator@example.com",
      password: "password1234",
      role: :moderator
    )

    @other_moderator = User.create!(
      name: "Other Moderator",
      email: "other@example.com",
      password: "password1234",
      role: :moderator
    )

    @place = Place.create!(
      name: "Central Park Bench",
      category: :seating,
      latitude: 47.3769,
      longitude: 8.5417,
      capacity: 3,
      proposed_by: @moderator,
      approved: false
    )

    post session_path, params: {
      email: @moderator.email,
      password: "password1234"
    }
  end

  test "moderator can view a pending place" do
    get "/moderation/places/#{@place.id}"

    assert_response :success
    assert_select "h1", /Place/i
  end

  test "moderator can approve a place" do
    post "/moderation/places/#{@place.id}/approve"

    assert_redirected_to "/moderation/places/#{@place.id}"
    assert @place.reload.approved
  end

  test "moderator can reject a place" do
    post "/moderation/places/#{@place.id}/reject"

    assert_redirected_to "/moderation/places/#{@place.id}"
    assert_not @place.reload.approved
  end

  test "another moderator cannot edit a locked place" do
    @place.update!(locked_by: @moderator, locked_at: Time.current)

    post session_path, params: {
      email: @other_moderator.email,
      password: "password1234"
    }

    get "/moderation/places/#{@place.id}/edit"

    assert_response :forbidden
  end
end
