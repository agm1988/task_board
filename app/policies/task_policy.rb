class TaskPolicy < ApplicationPolicy
  def permitted_attributes
    [:title, :description, :status]
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def update?
    true
  end

  def edit?
    update?
  end

  def destroy?
    record.author == user
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      if user.is_admin?
        scope.all
      else
        scope.joins(:author).where(users: { id: user.id })
      end
    end
  end
end
