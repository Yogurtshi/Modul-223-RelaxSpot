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
    assert_select "h1", @place.name
  end

  test "moderator can approve a place" do
    post "/moderation/places/#{@place.id}/approve"

    assert_redirected_to "/moderation/places/#{@place.id}"
    assert @place.reload.approved
  end

  test "moderator can edit a place" do
    get edit_moderation_place_path(@place)

    assert_response :success
    assert_select "h1", /Edit Central Park Bench/
    assert_select "form[action='#{moderation_place_path(@place)}']"

    patch moderation_place_path(@place), params: {
      place: {
        name: "Updated Park Bench",
        category: "shade",
        status: "occupied",
        capacity: 4,
        latitude: 47.377,
        longitude: 8.542,
        opening_hours: "08:00-20:00"
      }
    }

    assert_redirected_to moderation_place_path(@place)
    @place.reload
    assert_equal "Updated Park Bench", @place.name
    assert_equal "shade", @place.category
    assert_equal 4, @place.capacity
    assert_nil @place.locked_by_id
    assert_nil @place.locked_at
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

    assert_redirected_to moderation_dashboards_show_path
    assert_equal "Moderator User is currently editing this place. You were redirected to the moderation dashboard.", flash[:alert]
  end

  test "admin is redirected to the dashboard when a place is locked" do
    admin = User.create!(
      name: "Admin User",
      email: "admin-lock@example.com",
      password: "password1234",
      role: :admin
    )
    @place.update!(locked_by: @moderator, locked_at: Time.current)

    post session_path, params: {
      email: admin.email,
      password: "password1234"
    }

    get edit_moderation_place_path(@place)

    assert_redirected_to moderation_dashboards_show_path
    assert_equal "Moderator User is currently editing this place. You were redirected to the moderation dashboard.", flash[:alert]
  end

  test "moderator can take over an expired edit lock" do
    @place.update!(locked_by: @other_moderator, locked_at: 6.minutes.ago)

    get "/moderation/places/#{@place.id}/edit"

    assert_response :success
    assert_equal @moderator.id, @place.reload.locked_by_id
    assert_operator @place.locked_at, :>, 5.minutes.ago
  end
end
