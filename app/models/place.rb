class Place < ApplicationRecord
  has_paper_trail

  enum :category, {
    seating: 0,
    smoking: 1,
    shade: 2,
    toilet: 3
  }, default: :seating

  enum :status, {
    open: 0,
    occupied: 1,
    closed: 2,
    dirty: 3
  }, default: :open

  belongs_to :proposed_by,
             class_name: "User",
             inverse_of: :proposed_places

  belongs_to :locked_by,
             class_name: "User",
             optional: true,
             inverse_of: :locked_places

  has_many :check_ins, dependent: :destroy
  has_many :check_in_holds, dependent: :destroy
  has_many :status_reports, dependent: :destroy

  validates :name, presence: true
  validates :latitude, :longitude, presence: true
  validates :capacity, numericality: { only_integer: true, greater_than: 0 }
end
