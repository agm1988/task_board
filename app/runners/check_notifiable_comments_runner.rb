# frozen_string_literal: true

class CheckNotifiableCommentsRunner
  include Sidekiq::Worker

  # TODO: think more on query
  def perform
    report_ids_with_comments_on_tasks = Report
                                        .reported
                                        .joins(:task_comments)
                                        .where(comments: { need_notification: true })
                                        .pluck(:id)

    report_ids_with_comments_on_report = Report
                                         .reported
                                         .joins(:comments)
                                         .where(comments: { need_notification: true })
                                         .pluck(:id)

    report_ids = report_ids_with_comments_on_tasks + report_ids_with_comments_on_report

    report_ids.uniq.each do |report_id|
      Notifications::CommentNotificationJob.perform_async(report_id)
    end
  end
end
