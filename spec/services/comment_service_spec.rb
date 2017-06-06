# frozen_string_literal: true

require 'rails_helper'

describe CommentService do
  let!(:user) { create(:user) }
  let!(:task) { create(:task) }
  let!(:report) { create(:report, tasks: [task]) }

  let!(:reported_task) { create(:task) }
  let!(:reported_report) { create(:report, :reported, tasks: [reported_task]) }

  describe '#run' do
    context 'comment on not reported report' do
      specify 'comment on report' do
        result = CommentService.run(commentable: report, author: user, comment: 'some comment')

        comment = result.value

        expect(result).to be_an_instance_of(Maybe::Some)
        expect(comment).to be_persisted
        expect(comment.need_notification).to be false
        expect(comment.commentable).to eq(report)
      end

      specify 'comment on task' do
        result = CommentService.run(commentable: task, author: user, comment: 'some comment')

        comment = result.value

        expect(result).to be_an_instance_of(Maybe::Some)
        expect(comment).to be_persisted
        expect(comment.need_notification).to be false
        expect(comment.commentable).to eq(task)
      end

      specify 'without commnet body' do
        result = CommentService.run(commentable: task, author: user, comment: '')

        comment = result.value

        expect(result).to be_an_instance_of(Maybe::None)
        expect(comment).not_to be_persisted
      end

      specify 'without commnet body' do
        result = CommentService.run(commentable: report, author: user, comment: '')

        comment = result.value

        expect(result).to be_an_instance_of(Maybe::None)
        expect(comment).not_to be_persisted
      end
    end

    context 'comment on reported report' do
      specify 'comment on report' do
        result = CommentService.run(commentable: reported_report, author: user, comment: 'some comment')

        comment = result.value

        expect(result).to be_an_instance_of(Maybe::Some)
        expect(comment).to be_persisted
        expect(comment.need_notification).to be true
        expect(comment.commentable).to eq(reported_report)
      end

      specify 'comment on task' do
        result = CommentService.run(commentable: reported_task, author: user, comment: 'some comment')

        comment = result.value

        expect(result).to be_an_instance_of(Maybe::Some)
        expect(comment).to be_persisted
        expect(comment.need_notification).to be true
        expect(comment.commentable).to eq(reported_task)
      end

      specify 'without commnet body' do
        result = CommentService.run(commentable: reported_task, author: user, comment: '')

        comment = result.value

        expect(result).to be_an_instance_of(Maybe::None)
        expect(comment).not_to be_persisted
      end

      specify 'without commnet body' do
        result = CommentService.run(commentable: reported_report, author: user, comment: '')

        comment = result.value

        expect(result).to be_an_instance_of(Maybe::None)
        expect(comment).not_to be_persisted
      end
    end
  end
end
