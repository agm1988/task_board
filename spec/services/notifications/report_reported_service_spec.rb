# frozen_string_literal: true

require 'rails_helper'

describe Notifications::ReportReportedService do
  let!(:report) { create(:report, :reported) }

  describe '#run' do
    specify do
      mailer = double
      expect(NotificationsMailer).to receive(:report_reported).with(report.id) { mailer }
      expect(mailer).to receive(:deliver_now)

      Notifications::ReportReportedService.run(report.id)
    end
  end
end
