require "test_helper"

class CheckInTest < ActiveSupport::TestCase
  self.use_transactional_tests = false

  setup do
    @place = places(:one)
    @place.update!(capacity: 2)
    @user = User.create!(
      name: "Model Test User",
      email: "model-test@example.com",
      password: "password1234"
    )
  end

  teardown do
    CheckIn.where(user: @user).delete_all
    @user.destroy!
    @place.reload.update!(capacity: 4)
  end

  test "creates a check-in while capacity remains" do
    check_in = CheckIn.create_with_capacity!(
      place: @place,
      user: @user,
      expected_minutes: 30
    )

    assert check_in.persisted?
    assert_equal @user, check_in.user
  end

  test "raises when the place has no remaining capacity" do
    @place.update!(capacity: 1)
    CheckIn.create!(
      place: @place,
      user: users(:one),
      started_at: Time.current,
      ends_at: 30.minutes.from_now
    )

    assert_raises CheckIn::CapacityExceeded do
      CheckIn.create_with_capacity!(
        place: @place,
        user: @user,
        expected_minutes: 30
      )
    end
  end

  test "raises when the user already has an active check-in at the place" do
    CheckIn.create!(
      place: @place,
      user: @user,
      started_at: Time.current,
      ends_at: 30.minutes.from_now
    )

    assert_raises CheckIn::AlreadyCheckedIn do
      CheckIn.create_with_capacity!(
        place: @place,
        user: @user,
        expected_minutes: 30
      )
    end
  end

  test "rejects a check-in that ends before it starts" do
    check_in = CheckIn.new(
      place: @place,
      user: @user,
      started_at: 30.minutes.from_now,
      ends_at: Time.current
    )

    assert_not check_in.valid?
    assert_includes check_in.errors[:ends_at], "must be after the start time"
  end

  test "concurrent check-ins cannot exceed the remaining capacity" do
    @place.update!(capacity: 1)
    other_user = User.create!(
      name: "Concurrent User",
      email: "concurrent-user@example.com",
      password: "password1234"
    )
    ready = Queue.new
    start = Queue.new
    outcomes = Queue.new

    threads = [ @user, other_user ].map do |user|
      Thread.new do
        ActiveRecord::Base.connection_pool.with_connection do
          ready << true
          start.pop

          begin
            CheckIn.create_with_capacity!(
              place: @place,
              user: user,
              expected_minutes: 30
            )
            outcomes << :success
          rescue CheckIn::CapacityExceeded, ActiveRecord::StatementInvalid
            outcomes << :rejected
          end
        end
      end
    end

    2.times { ready.pop }
    2.times { start << true }
    threads.each(&:join)

    results = 2.times.map { outcomes.pop }
    assert_equal 1, results.count(:success)
    assert_equal 1, results.count(:rejected)
    assert_equal 1, CheckIn.active.where(place: @place).count
  ensure
    other_user&.destroy!
  end
end
