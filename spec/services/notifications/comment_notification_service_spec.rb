# frozen_string_literal: true

require 'rails_helper'

describe Notifications::CommentNotificationService do
  let!(:task) { create(:task) }
  let!(:report) { create(:report, :reported, tasks: [task]) }

  let!(:old_task_comment) { create(:comment, commentable: task) }
  let!(:old_report_comment) { create(:comment, commentable: report) }

  let!(:new_task_comment) { create(:comment, :needs_notification, commentable: task) }
  let!(:new_report_comment) { create(:comment, :needs_notification, commentable: report) }

  describe '#run' do
    specify do
      expect(new_task_comment.need_notification).to be true
      expect(new_report_comment.need_notification).to be true

      Notifications::CommentNotificationService.run(report.id)

      new_task_comment.reload
      new_report_comment.reload

      expect(new_task_comment.need_notification).to be false
      expect(new_report_comment.need_notification).to be false
    end

    specify do
      mailer = double

      expect(NotificationsMailer)
        .to receive(:comments_notify).with(report.id, [new_report_comment], [new_task_comment]) { mailer }
      expect(mailer).to receive(:deliver_now)

      Notifications::CommentNotificationService.run(report.id)
    end
  end
end
