class PhotoPolicy < ApplicationPolicy
  def create?
    user.present?
  end
end
