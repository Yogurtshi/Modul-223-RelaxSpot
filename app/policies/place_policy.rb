class PlacePolicy < ApplicationPolicy
  def show?
    true
  end

  def create?
    user.present?
  end

  def update?
    admin? || moderator?
  end

  def approve?
    moderator?
  end

  def reject?
    moderator?
  end

  def unlock?
    moderator?
  end
end
