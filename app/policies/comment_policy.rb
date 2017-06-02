class CommentPolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    user.is_admin? || record.user == user
  end
end
