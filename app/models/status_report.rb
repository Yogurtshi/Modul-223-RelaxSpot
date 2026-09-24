class StatusReport < ApplicationRecord
  has_paper_trail

  belongs_to :place
  belongs_to :user

  enum :reported_status, {
    occupied: 0,
    closed: 1,
    dirty: 2
  }, default: :occupied

  validates :reported_status, presence: true
end
