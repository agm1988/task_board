# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TasksController, type: :controller do
  let!(:admin) { create(:user, :admin) }
  let!(:first_user) { create(:user) }
  let!(:second_user) { create(:user) }
  let(:tag) { create(:tag) }

  let(:reported_task) { create(:task, tags: [tag]) }

  let(:first_report_task1) { create(:task, tags: [tag]) }
  let(:first_report_task2) { create(:task, tags: [tag]) }

  let(:second_report_task1) { create(:task, tags: [tag]) }
  let(:second_report_task2) { create(:task, tags: [tag]) }

  let!(:first_user_report) { create(:report, user: first_user, tasks: [first_report_task1, first_report_task2]) }
  let!(:second_user_report) { create(:report, user: second_user, tasks: [second_report_task1, second_report_task2]) }

  let!(:reported_report) { create(:report, :reported, user: first_user, tasks: [reported_task]) }
  context 'logged in as admin' do
    before do
      login_as_user(admin)
    end

    describe '#show' do
      specify 'shows any task' do
        get :show, id: first_report_task1.to_param

        expect(response).to be_success
        expect(assigns(:task)).to eq(first_report_task1)
      end
    end

    describe '#edit' do
      specify 'shows form' do
        get :edit, id: first_report_task1.to_param

        expect(response).to be_success
      end

      specify 'not allow edit task from reported report' do
        get :edit, id: reported_task.to_param

        expect(response).to be_redirect
      end
    end

    describe '#update' do
      specify 'updates with valid params' do
        put :update, id: first_report_task1.to_param, task: { title: 'new title' }

        first_report_task1.reload
        expect(response).to redirect_to(task_path(first_report_task1))
        expect(first_report_task1.title).to eq('new title')
      end

      specify 'not update with invalid params' do
        expect do
          put :update, id: first_report_task1.to_param, task: { title: '' }
        end.not_to change(admin, :last_name)
      end

      specify 'not update task from reported report' do
        expect do
          put :update, id: reported_task.to_param, task: { title: 'new title' }
        end.not_to change(reported_task, :title)
      end
    end

    describe '#destroy' do
      specify 'deletes task' do
        expect { delete :destroy, id: first_report_task1.to_param }
          .to change(Task, :count).by(-1)
      end

      specify 'can\'t destroy task from reported report' do
        expect { delete :destroy, id: reported_task.to_param }
          .not_to change(Task, :count)
      end
    end
  end

  context 'logged in as user' do
    before do
      login_as_user(first_user)
    end

    describe '#show' do
      specify 'shows task' do
        get :show, id: first_report_task1.to_param

        expect(response).to be_success
        expect(assigns(:task)).to eq(first_report_task1)
      end

      specify 'don\'t show another user\'s task' do
        get :show, id: second_report_task1.to_param

        expect(response).to be_redirect
      end
    end

    describe '#edit' do
      specify 'shows form' do
        get :edit, id: first_report_task1.to_param

        expect(response).to be_success
      end

      specify 'not allow edit task from reported report' do
        get :edit, id: reported_task.to_param

        expect(response).to be_redirect
      end
    end

    describe '#update' do
      specify 'updates with valid params' do
        put :update, id: first_report_task1.to_param, task: { title: 'new title' }

        first_report_task1.reload
        expect(response).to redirect_to(task_path(first_report_task1))
        expect(first_report_task1.title).to eq('new title')
      end

      specify 'not update with invalid params' do
        expect do
          put :update, id: first_report_task1.to_param, task: { title: '' }
        end.not_to change(admin, :last_name)
      end

      specify 'not update task from reported report' do
        expect do
          put :update, id: reported_task.to_param, task: { title: 'new title' }
        end.not_to change(reported_task, :title)
      end
    end

    describe '#destroy' do
      specify 'deletes task' do
        expect { delete :destroy, id: first_report_task1.to_param }
          .to change(Task, :count).by(-1)
      end

      specify 'can\'t destroy task from reported report' do
        expect { delete :destroy, id: reported_task.to_param }
          .not_to change(Task, :count)
      end

      specify 'can\'t destroy another user\'s task from reported report' do
        expect { delete :destroy, id: second_report_task1.to_param }
          .not_to change(Task, :count)
      end
    end
  end
end
