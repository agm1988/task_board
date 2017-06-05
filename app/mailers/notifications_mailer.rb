# frozen_string_literal: true

class NotificationsMailer < ApplicationMailer
  helper NotificationsMailerHelper

  # TODO: in env variables or in secrets.yml
  ADMIN_EMAILS = ENV['admin_emails'] || %w[admin@admin.com].freeze

  def report_reported(report_id)
    @report = Report.includes(:tasks, :user).find(report_id)
    @user = @report.user

    mail(to: ADMIN_EMAILS, subject: t('.subject'))
  end

  # TODO: notify everybody except commenter
  def comments_notify(report_id, report_comemnts, task_comments)
    @report = Report.find(report_id)
    @report_comments = report_comemnts
    @task_comments = task_comments

    mail(to: ADMIN_EMAILS, subject: t('.subject'))
  end

  def user_report_reminder(user)
    @user = user
    @till_time = Time.zone.now.utc.change(min: user.work_start_time.min)

    mail(to: @user.email, subject: t('.subject'))
  end
end
