# frozen_string_literal: true

class UserPolicy < ApplicationPolicy
  def permitted_attributes
    if user.is_admin?
      %i[first_name last_name email is_admin nickname work_start_time password password_confirmation]
    elsif user == record
      %i[first_name last_name email nickname work_start_time password password_confirmation]
    end
  end

  def index?
    true
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    user.is_admin?
  end

  def new?
    create?
  end

  def update?
    user.is_admin? || user == record
  end

  def edit?
    update?
  end

  def destroy?
    user.is_admin? && record != user
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
        scope.where(id: user.id)
      end
    end
  end
end
