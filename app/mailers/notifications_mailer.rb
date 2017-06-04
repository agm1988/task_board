class NotificationsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.notifications_mailer.report_reported.subject
  #
  def report_reported(report_id)
    @report = Report.includes(:tasks, :user).find(report_id)
    @user = @report.user

    mail to: "to@example.org"
  end
end
