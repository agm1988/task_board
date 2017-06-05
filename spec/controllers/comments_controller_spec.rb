# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CommentsController, type: :controller do
  let!(:admin) { create(:user, :admin) }
  let!(:first_user) { create(:user) }
  let!(:draft_report) { create(:report, user: first_user) }
  let!(:reported_report) { create(:report, :reported, user: first_user) }
  let(:draft_task) { draft_report.tasks.last }
  let(:reported_task) { reported_report.tasks.last }

  let!(:draft_report_comment) { create(:comment, user: first_user, commentable: draft_report) }
  let!(:reported_report_comment) { create(:comment, user: first_user, commentable: reported_report) }

  let!(:draft_task_comment) { create(:comment, user: first_user, commentable: draft_task) }
  let!(:reported_task_comment) { create(:comment, user: first_user, commentable: reported_task) }

  let!(:another_user_comment) { create(:comment, user: admin, commentable: draft_task) }

  describe '#create' do
    context 'logged in as admin' do
      before do
        login_as_user(admin)
      end

      context 'valid comment params' do
        specify 'can leave comment for draft report' do
          expect do
            post :create, report_id: draft_report.to_param, comment: { body: 'some text' }
          end.to change(Comment, :count).by(1)
        end

        specify 'can leave comment for reported report' do
          expect do
            post :create, report_id: reported_report.to_param, comment: { body: 'some text' }
          end.to change(Comment, :count).by(1)
        end

        specify 'can leave comment for draft report task' do
          expect do
            post :create, task_id: draft_task.to_param, comment: { body: 'some text' }
          end.to change(Comment, :count).by(1)
        end

        specify 'can leave comment for reported report task' do
          expect do
            post :create, task_id: reported_task.to_param, comment: { body: 'some text' }
          end.to change(Comment, :count).by(1)
        end
      end

      specify 'can\'t leave blank comment for task' do
        expect do
          post :create, task_id: reported_task.to_param, comment: { body: '' }
        end.not_to change(Comment, :count)
      end

      specify 'can\'t leave blank comment for report' do
        expect do
          post :create, report_id: reported_report.to_param, comment: { body: '' }
        end.not_to change(Comment, :count)
      end
    end

    context 'logged in as user' do
      before do
        login_as_user(first_user)
      end

      context 'valid comment params' do
        specify 'can leave comment for draft report' do
          expect do
            post :create, report_id: draft_report.to_param, comment: { body: 'some text' }
          end.to change(Comment, :count).by(1)
        end

        specify 'can leave comment for reported report' do
          expect do
            post :create, report_id: reported_report.to_param, comment: { body: 'some text' }
          end.to change(Comment, :count).by(1)
        end

        specify 'can leave comment for draft report task' do
          expect do
            post :create, task_id: draft_task.to_param, comment: { body: 'some text' }
          end.to change(Comment, :count).by(1)
        end

        specify 'can leave comment for reported report task' do
          expect do
            post :create, task_id: reported_task.to_param, comment: { body: 'some text' }
          end.to change(Comment, :count).by(1)
        end
      end

      specify 'can\'t leave blank comment for task' do
        expect do
          post :create, task_id: reported_task.to_param, comment: { body: '' }
        end.not_to change(Comment, :count)
      end

      specify 'can\'t leave blank comment for report' do
        expect do
          post :create, report_id: reported_report.to_param, comment: { body: '' }
        end.not_to change(Comment, :count)
      end
    end
  end

  describe '#destroy' do
    context 'logged in as admin' do
      before do
        login_as_user(admin)
      end

      specify 'destroy comment on draft task' do
        expect do
          delete :destroy, task_id: draft_task.to_param, id: draft_task_comment.to_param
        end.to change(Comment, :count).by(-1)
      end

      specify 'destroy comment on draft report' do
        expect do
          delete :destroy, report_id: draft_report.to_param, id: draft_report_comment.to_param
        end.to change(Comment, :count).by(-1)
      end

      specify 'can\'t destroy comment on reported task' do
        expect do
          delete :destroy, task_id: reported_task.to_param, id: reported_task_comment.to_param
        end.not_to change(Comment, :count)
      end

      specify 'can\'t destroy comment on reported report' do
        expect do
          delete :destroy, report_id: reported_report.to_param, id: reported_report_comment.to_param
        end.not_to change(Comment, :count)
      end
    end

    context 'logged in as user' do
      before do
        login_as_user(first_user)
      end

      specify 'destroy comment own on draft task' do
        expect do
          delete :destroy, task_id: draft_task.to_param, id: draft_task_comment.to_param
        end.to change(Comment, :count).by(-1)
      end

      specify 'destroy comment on own draft report' do
        expect do
          delete :destroy, report_id: draft_report.to_param, id: draft_report_comment.to_param
        end.to change(Comment, :count).by(-1)
      end

      specify 'can\'t destroy own comment on reported task' do
        expect do
          delete :destroy, task_id: reported_task.to_param, id: reported_task_comment.to_param
        end.not_to change(Comment, :count)
      end

      specify 'can\'t destroy own comment on reported report' do
        expect do
          delete :destroy, report_id: reported_report.to_param, id: reported_report_comment.to_param
        end.not_to change(Comment, :count)
      end

      specify 'can\'t destroy another user\'s comment on draft task' do
        expect do
          delete :destroy, task_id: draft_task.to_param, id: another_user_comment.to_param
        end.not_to change(Comment, :count)
      end
    end
  end
end
