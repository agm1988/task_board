# frozen_string_literal: true

class TaskPolicy < ApplicationPolicy
  def permitted_attributes
    %i[title description status]
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def update?
    can_be_edited?
  end

  def edit?
    update?
  end

  def destroy?
    can_be_edited? && (record.author == user || user.is_admin?)
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  def can_be_edited?
    record.report.draft?
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
