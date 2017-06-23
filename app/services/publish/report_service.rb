# frozen_string_literal: true

module Publish
  class ReportService
    def self.run(report)
      ::Publish::PublisherService.run('/reports/new', id: report.id)
    end
  end
end
