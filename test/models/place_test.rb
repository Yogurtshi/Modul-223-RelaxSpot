require "test_helper"

class PlaceTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @place = Place.new(
      name: "Test Place",
      category: :seating,
      status: :open,
      latitude: 47.3769,
      longitude: 8.5417,
      capacity: 2,
      proposed_by: @user
    )
  end

  test "requires the core place details" do
    @place.name = nil
    @place.latitude = nil
    @place.longitude = nil

    assert_not @place.valid?
    assert_includes @place.errors[:name], "can't be blank"
    assert_includes @place.errors[:latitude], "can't be blank"
    assert_includes @place.errors[:longitude], "can't be blank"
  end

  test "requires a positive integer capacity" do
    @place.capacity = 0

    assert_not @place.valid?
    assert_includes @place.errors[:capacity], "must be greater than 0"
  end

  test "supports the defined category and status values" do
    assert @place.seating?
    assert @place.open?

    @place.category = :shade
    @place.status = :occupied

    assert @place.shade?
    assert @place.occupied?
  end
end
