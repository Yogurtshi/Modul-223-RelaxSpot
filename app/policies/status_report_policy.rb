class StatusReportPolicy < ApplicationPolicy
  def show?
    user.present?
  end

  def create?
    user.present?
  end

  def update?
    moderator?
  end

  def approve?
    moderator?
  end

  def reject?
    moderator?
  end
end
