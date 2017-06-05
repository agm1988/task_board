module Notifications
  class UserReportReminderService
    def self.run(user_id)
      user = User.find(user_id)
      NotificationsMailer.user_report_reminder(user).deliver_now
    end
  end
end
