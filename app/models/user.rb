class User < ApplicationRecord
  has_secure_password

  enum :role, {
    user: 0,
    moderator: 1,
    admin: 2
  }, default: :user

  normalizes :email, with: ->(email) { email.strip.downcase }

  has_many :proposed_places,
           class_name: "Place",
           foreign_key: :proposed_by_id,
           inverse_of: :proposed_by

  has_many :locked_places,
           class_name: "Place",
           foreign_key: :locked_by_id,
           inverse_of: :locked_by

  has_many :check_ins, dependent: :destroy
  has_many :status_reports, dependent: :destroy

  validates :name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 12 }, allow_nil: true
end
