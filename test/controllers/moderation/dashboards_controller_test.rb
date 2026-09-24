require "test_helper"

class Moderation::DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get show and display recent activity feed" do
    user = User.create!(name: "Moderator User", email: "moderator@example.com", password: "password1234")
    place = Place.create!(
      name: "Central Park Bench",
      category: :seating,
      latitude: 47.3769,
      longitude: 8.5417,
      capacity: 3,
      proposed_by: user
    )
    place.update!(name: "Central Park Bench Updated")

    get moderation_dashboards_show_url

    assert_response :success
    assert_select "h1", /Recent activity|Activity feed/i
    assert_select "li", /Place/i
  end
end
