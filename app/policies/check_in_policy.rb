class CheckInPolicy < ApplicationPolicy
  def show?
    record.user == user
  end

  def create?
    user.present? && record.place&.approved?
  end
end