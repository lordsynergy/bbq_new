class CommentPolicy < ApplicationPolicy
  def create?
    if user.present?
      user
    else
      'Anonymous'
    end
  end
end
