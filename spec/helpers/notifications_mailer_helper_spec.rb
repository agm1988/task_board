# frozen_string_literal: true

require 'rails_helper'

RSpec.describe NotificationsMailerHelper, type: :helper do
  let!(:report) { create(:report) }
  let!(:task) { create(:task) }

  let!(:report_comment) { create(:comment, commentable: report) }
  let!(:task_comment) { create(:comment, commentable: task) }

  describe '#comment_url_with_anchor' do
    specify do
      expect(helper.comment_url_with_anchor(report_comment))
        .to match("reports/#{report.id}#comment_#{report_comment.id}")
    end

    specify do
      expect(helper.comment_url_with_anchor(task_comment))
        .to match("tasks/#{task.id}#comment_#{task_comment.id}")
    end
  end
end
