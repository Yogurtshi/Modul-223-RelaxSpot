class ProfilePolicy < ApplicationPolicy
  def show?
    own_record?
  end

  def update?
    own_record?
  end

  def confirm_email?
    own_record?
  end

  private

  def own_record?
    user.present? && record == user
  end
end