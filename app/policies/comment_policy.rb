class CommentPolicy < ApplicationPolicy
  def create?
    true
  end

  def destroy?
    can_be_destroyed? && (user.is_admin? || record.user == user)
  end

  private

  def can_be_destroyed?
    commentable = record.commentable
    case commentable
    when Report
      commentable.draft?
    when Task
      commentable.report.draft?
    end
  end
end
