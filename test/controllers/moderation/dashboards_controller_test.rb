require "test_helper"

class Moderation::DashboardsControllerTest < ActionDispatch::IntegrationTest
  test "should get show and display recent activity feed" do
    user = User.create!(name: "Moderator User", email: "moderator@example.com", password: "password1234", role: :moderator)
    place = Place.create!(
      name: "Central Park Bench",
      category: :seating,
      latitude: 47.3769,
      longitude: 8.5417,
      capacity: 3,
      proposed_by: user
    )
    place.update!(name: "Central Park Bench Updated")
    status_report = StatusReport.create!(place: place, user: user, reported_status: :dirty)

    post session_path, params: { email: user.email, password: "password1234" }

    get moderation_dashboards_show_url

    assert_response :success
    assert_select "h1", /Dashboard/i
    assert_select "li", /Place/i
    assert_select "h2", /Users/i
    assert_select "h2", /Place suggestions/i
    assert_select "h2", /Status reports/i
    assert_select "a.dashboard-suggestion-card__link[href='#{moderation_place_path(place)}']"
    assert_select "a.dashboard-suggestion-card__link[href='#{moderation_status_report_path(status_report)}']"
    assert_select "a", { text: "Review", count: 0 }
  end

  test "admin can open a user profile from the dashboard" do
    admin = User.create!(name: "Dashboard Admin", email: "dashboard-admin@example.com", password: "password1234", role: :admin)
    user = User.create!(name: "Dashboard User", email: "dashboard-user@example.com", password: "password1234")
    post session_path, params: { email: admin.email, password: "password1234" }

    get moderation_dashboards_show_url

    assert_select "a[href='#{admin_user_path(user)}']", text: /#{user.name}/
    assert_select "a.dashboard-user-card__link[href='#{admin_user_path(user)}']"
    assert_select "button", { text: /Block|Unblock/, count: 0 }
  end

  test "regular users cannot access the dashboard" do
    user = User.create!(name: "Regular User", email: "regular-dashboard@example.com", password: "password1234")
    post session_path, params: { email: user.email, password: "password1234" }

    get moderation_dashboards_show_url

    assert_response :forbidden
  end
end
