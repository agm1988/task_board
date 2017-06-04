module Notifications
  class ReportReportedService
    def self.run(report_id)
      NotificationsMailer.report_reported(report_id).deliver_now
    end
  end
end
