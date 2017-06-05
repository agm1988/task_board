module Notifications
  class UserReportReminderJob
    include Sidekiq::Worker

    sidekiq_options retry: false,
                    queue: :mailers

    # TODO: add check if job already enqueued
    def perform(user_id)
      return unless user_id
      Notifications::UserReportReminderService.run(user_id)
    end
  end
end
