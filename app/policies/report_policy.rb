# frozen_string_literal: true

class ReportPolicy < ApplicationPolicy
  def permitted_attributes
    # disallow to update user_id for existing records
    if record == Report
      [:user_id, :title, tasks_attributes: [:id, :title, :description, :status, :_destroy, tag_ids: []]]
    else
      [:title, tasks_attributes: [:id, :title, :description, :status, :_destroy, tag_ids: []]]
    end
  end

  def index?
    true
  end

  def show?
    scope.where(id: record.id).exists?
  end

  def create?
    # true
    # admin can do everything, almost :)
    # user can create only one report in draft status.
    # Submit report, than create next
    user.is_admin? || user.reports.draft.none?
  end

  def new?
    create?
  end

  def update?
    can_be_edited? && (user.is_admin? || report_author?)
  end

  def edit?
    update?
  end

  def destroy?
    can_be_edited? && (user.is_admin? || report_author?)
  end

  def mark_as_reported?
    record.draft? && report_author?
  end

  def scope
    Pundit.policy_scope!(user, record.class)
  end

  def report_author?
    user.id == record.user_id
  end

  def can_be_edited?
    record.draft?
  end

  class Scope
    attr_reader :user, :scope

    def initialize(user, scope)
      @user = user
      @scope = scope
    end

    def resolve
      # if user.is_admin?
      #   scope.all
      # else
      #   scope.where(user_id: user.id)
      # end

      scope.all
    end
  end
end
