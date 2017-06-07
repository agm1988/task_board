# frozen_string_literal: true

class NotificationsMailerPreview < ActionMailer::Preview
  def report_reported
    NotificationsMailer.report_reported
  end
end
