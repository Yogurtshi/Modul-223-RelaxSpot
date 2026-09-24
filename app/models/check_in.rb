class CheckIn < ApplicationRecord
  has_paper_trail

  belongs_to :place
  belongs_to :user

  scope :active, -> { where("ends_at > ?", Time.current) }

  validates :started_at, :ends_at, presence: true
  validate :ends_after_started_at
  validate :user_has_no_active_check_in_at_place

  class CapacityExceeded < StandardError
  end

  class AlreadyCheckedIn < StandardError
  end

  def self.create_with_capacity!(place:, user:, expected_minutes:)
    transaction do
      locked_place = Place.lock.find(place.id)

      if locked_place.check_ins.active.count >= locked_place.capacity
        raise CapacityExceeded, "Place is currently full"
      end

      if locked_place.check_ins.active.where(user_id: user.id).exists?
        raise AlreadyCheckedIn, "You are already checked in at this place"
      end

      started_at = Time.current

      create!(
        place: locked_place,
        user: user,
        started_at: started_at,
        ends_at: started_at + expected_minutes.minutes
      )
    end
  end

  private

  def ends_after_started_at
    return if started_at.blank? || ends_at.blank?
    return if ends_at > started_at

    errors.add(:ends_at, "must be after the start time")
  end

  def user_has_no_active_check_in_at_place
    return if place.blank? || user.blank?

    if place.check_ins.active.where.not(id: id).where(user_id: user.id).exists?
      errors.add(:base, "You are already checked in at this place")
    end
  end
end
