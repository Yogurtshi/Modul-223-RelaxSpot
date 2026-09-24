class UserPolicy < ApplicationPolicy
  def index?
    admin?
  end

  def show?
    admin?
  end

  def update?
    admin?
  end

  def promote?
    admin?
  end

  def demote?
    admin?
  end

  def lock?
    admin?
  end

  def unlock?
    admin?
  end

  def moderate?
    moderator?
  end
end
