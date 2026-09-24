require "test_helper"

class PlacesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get places_url
    assert_response :success
  end

  test "places index shows active occupancy over capacity" do
    CheckIn.create!(
      place: places(:one),
      user: users(:one),
      started_at: 10.minutes.ago,
      ends_at: 20.minutes.from_now
    )

    get places_url

    assert_response :success
    assert_select ".spot-card__capacity", /1\/4/
  end

  test "places index filters by category" do
    get places_url, params: { category: "shade" }

    assert_response :success
    assert_select ".spot-card h2", text: "Shaded Courtyard"
    assert_select ".spot-card h2", { text: "Central Bench", count: 0 }
  end

  test "places index filters by name and status" do
    places(:one).update!(name: "Open Garden", status: :open)
    places(:two).update!(name: "Closed Garden", status: :closed)

    get places_url, params: { search: "garden", status: "closed" }

    assert_response :success
    assert_select ".spot-card h2", text: "Closed Garden"
    assert_select ".spot-card h2", { text: "Open Garden", count: 0 }
  end

  test "anonymous users cannot get new place form" do
    get new_place_url
    assert_redirected_to new_session_url
  end

  test "should get show" do
    get place_url(places(:one))
    assert_response :success
  end

  test "availability reports active check-ins and capacity" do
    places(:one).update!(capacity: 2)
    CheckIn.create!(
      place: places(:one),
      user: users(:one),
      started_at: 10.minutes.ago,
      ends_at: 20.minutes.from_now
    )

    get availability_place_url(places(:one))

    assert_response :success
    assert_equal 1, response.parsed_body["active_count"]
    assert_equal 0, response.parsed_body["held_count"]
    assert_equal 1, response.parsed_body["total_count"]
    assert_equal 2, response.parsed_body["capacity"]
  end

  test "authenticated user sees a disabled check-in control when the place is full" do
    user = User.create!(
      name: "Full Place User",
      email: "full-place-user@example.com",
      password: "secure-password"
    )
    place = places(:one)
    place.update!(capacity: 1)
    CheckIn.create!(
      place: place,
      user: users(:one),
      started_at: 10.minutes.ago,
      ends_at: 20.minutes.from_now
    )

    post session_url, params: { email: user.email, password: "secure-password" }
    get place_url(place)

    assert_response :success
    assert_select ".action-button--disabled", text: "Place is full"
    assert_select "a.action-button", { text: "Check in here", count: 0 }
  end

  test "authenticated users can create places" do
    user = User.create!(
      name: "Place Proposer",
      email: "place-proposer@example.com",
      password: "secure-password"
    )

    post session_url, params: {
      email: user.email,
      password: "secure-password"
    }

    assert_difference("Place.count", 1) do
      post places_url, params: {
        place: {
          name: "New Place",
          category: "seating",
          latitude: 47.3769,
          longitude: 8.5417,
          capacity: 2
        }
      }
    end

    created_place = Place.order(:created_at).last
    assert_redirected_to places_url
    assert_equal false, created_place.approved?
  end
end
