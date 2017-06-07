# frozen_string_literal: true

require 'rails_helper'

describe Notifications::UserReportReminderService do
  let!(:user) { create(:user) }

  describe '#run' do
    specify do
      mailer = double
      expect(NotificationsMailer).to receive(:user_report_reminder).with(user) { mailer }
      expect(mailer).to receive(:deliver_now)

      Notifications::UserReportReminderService.run(user.id)
    end
  end
end
