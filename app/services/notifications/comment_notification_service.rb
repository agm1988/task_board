# frozen_string_literal: true

module Notifications
  class CommentNotificationService
    # TODO: needs refactor
    def self.run(report_id)
      return unless report_id

      report = Report.find(report_id)

      new_report_comments = report.comments.notification_needed
      new_task_comments = report.task_comments.notification_needed

      NotificationsMailer.comments_notify(report_id, new_report_comments, new_task_comments).deliver_now

      new_report_comments.update_all(need_notification: false)
      new_task_comments.update_all(need_notification: false)
    end
  end
end
