class NotificationsMailer < ApplicationMailer
  helper NotificationsMailerHelper

  # TODO: in env variables or in secrets.yml
  ADMIN_EMAILS = ENV['admin_emails'] || %w(admin@admin.com).freeze

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.report_reported.subject
  #
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
end
