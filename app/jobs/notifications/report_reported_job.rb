module Notifications
  # TODO: rename :)
  class ReportReportedJob
    include Sidekiq::Worker

    sidekiq_options retry: true,
                    queue: :mailers

    def perform(report_id)
      return unless report_id
      Notifications::ReportReportedService.run(report_id)
    end
  end
end
