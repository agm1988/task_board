# frozen_string_literal: true

module Notifications
  class CommentNotificationJob
    include Sidekiq::Worker

    sidekiq_options retry: false,
                    queue: :mailers

    def perform(report_id)
      return unless report_id
      Notifications::CommentNotificationService.run(report_id)
    end
  end
end
