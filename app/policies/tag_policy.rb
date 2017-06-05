# frozen_string_literal: true

class TagPolicy < ApplicationPolicy
  def permitted_attributes
    %i[name] if user.is_admin?
  end

  def index?
    true
  end

  def show?
    true
  end

  def create?
    user.is_admin?
  end

  def new?
    create?
  end

  def update?
    user.is_admin?
  end

  def edit?
    update?
  end

  def destroy?
    user.is_admin?
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
      scope.all
    end
  end
end
