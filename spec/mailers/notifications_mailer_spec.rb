# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsMailer, type: :mailer do
  describe 'report_reported' do
    let!(:report) { create(:report) }

    let(:mail) { NotificationsMailer.report_reported(report.id) }

    it 'renders the headers' do
      expect(mail.subject).to eq('Отчет сформирован')
      expect(mail.to).to eq(['admin@admin.com'])
      expect(mail.from).to eq(['no-replay@taskboard.com'])
    end
  end
end
