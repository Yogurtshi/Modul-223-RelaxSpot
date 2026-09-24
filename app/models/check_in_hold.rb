class CheckInHold < ApplicationRecord
  HOLD_DURATION = 2.minutes

  belongs_to :place
  belongs_to :user

  scope :active, -> { where("expires_at > ?", Time.current) }

  def active?
    expires_at > Time.current
  end

  def self.claim!(place:, user:)
    transaction do
      locked_place = Place.lock.find(place.id)
      hold = find_or_initialize_by(place: locked_place, user: user)
      hold.expires_at = HOLD_DURATION.from_now

      available = locked_place.check_ins.active.count + locked_place.check_in_holds.active.where.not(user_id: user.id).count
      raise CapacityExceeded, "Place is currently full" if available >= locked_place.capacity

      hold.save!
      hold
    end
  end

  class CapacityExceeded < StandardError
  end
end
