require "test_helper"

class PlacePolicyTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: "Regular User", email: "user@example.com", password: "password1234")
    @moderator = User.new(name: "Moderator", email: "moderator@example.com", password: "password1234", role: :moderator)
    @admin = User.new(name: "Admin", email: "admin@example.com", password: "password1234", role: :admin)
    @place = Place.new(name: "Test Place", latitude: 47.3769, longitude: 8.5417, capacity: 3, proposed_by: @user)
  end

  test "regular user can view places" do
    assert PlacePolicy.new(@user, @place).show?
  end

  test "moderator can approve places" do
    assert PlacePolicy.new(@moderator, @place).approve?
  end

  test "admin can manage places" do
    assert PlacePolicy.new(@admin, @place).update?
  end
end
