class CheckIn < ApplicationRecord
  belongs_to :place
  belongs_to :user

  scope :active, -> { where("ends_at > ?", Time.current) }

  validates :started_at, :ends_at, presence: true
  validate :ends_after_started_at

  private

  def ends_after_started_at
    return if started_at.blank? || ends_at.blank?
    return if ends_at > started_at

    errors.add(:ends_at, "must be after the start time")
  end
end
