class EventPolicy < ApplicationPolicy
  def index?
    true
  end

  def show?
    password_guard!
  end

  def new?
    create?
  end

  def create?
    user.present?
  end

  def edit?
    current_user_can_edit?
  end

  class Scope < Scope
    def resolve
      scope.all
    end
  end

  private

  def password_guard!
    return true if record.pincode.blank?
    return true if user.present? && user == record.user
    return true if record.pincode_valid?(cookies["events_#{record.id}_pincode"])

    false
  end
end
