# frozen_string_literal: true

require 'rails_helper'

RSpec.describe ReportsController, type: :controller do
  let!(:admin) { create(:user, :admin) }
  let!(:first_user) { create(:user) }
  let!(:second_user) { create(:user) }

  let!(:draft_report) { create(:report, user: first_user) }
  let!(:draft_report2) { create(:report, user: second_user) }
  let!(:reported_report) { create(:report, :reported, user: first_user) }
  let!(:tag) { create(:tag) }

  let(:valid_report_attributes) do
    {
      user_id: first_user.id,
      title: 'some title',
      tasks_attributes: [
        title: 'task title',
        description: 'task description',
        status: 'todo',
        _destroy: false,
        tag_ids: [tag.id]
      ]
    }
  end

  describe '#index' do
    context 'logged as admin' do
      before do
        login_as_user(admin)

        get :index
      end

      it 'returns a success response' do
        expect(response).to be_success
        expect(assigns(:reports)).to match_array([draft_report, draft_report2, reported_report])
      end
    end

    context 'logged as user' do
      before do
        login_as_user(first_user)

        get :index
      end

      it 'returns a success response' do
        expect(response).to be_success
        expect(assigns(:reports)).to match_array([draft_report, draft_report2, reported_report])
      end
    end
  end

  describe '#show' do
    context 'logged as admin' do
      before do
        login_as_user(admin)
      end

      specify 'shows reported report' do
        get :show, id: reported_report.id

        expect(response).to be_success
        expect(assigns(:report)).to eq(reported_report)
      end

      specify 'shows draft report' do
        get :show, id: draft_report.id

        expect(response).to be_success
        expect(assigns(:report)).to eq(draft_report)
      end
    end

    context 'logged as user' do
      before do
        login_as_user(first_user)
      end

      specify 'shows own record' do
        get :show, id: draft_report.id

        expect(response).to be_success
        expect(assigns(:report)).to eq(draft_report)
      end

      specify 'showing another user\'s record' do
        get :show, id: draft_report2.to_param

        expect(assigns(:report)).to eq(draft_report2)
      end
    end
  end

  describe '#new' do
    context 'logged as admin' do
      before do
        login_as_user(admin)
      end

      specify 'shows form' do
        get :new

        expect(response).to be_success
      end
    end

    context 'logged as user' do
      before do
        login_as_user(first_user)
      end

      specify 'shows form' do
        get :new

        expect(response).to be_success
      end
    end
  end

  describe '#create' do
    context 'logged as admin' do
      before do
        login_as_user(admin)
      end

      specify 'creates new report' do
        expect do
          post :create, report: valid_report_attributes
        end.to change(Report, :count).by(1)
      end

      context 'report is not created' do
        specify 'not creating a record with invalid params' do
          expect do
            post :create, report: { title: '' }
          end.not_to change(Report, :count)
        end

        specify 'renders new template' do
          post :create, report: { title: '' }

          expect(response).to render_template(:new)
        end
      end
    end

    context 'logged as user' do
      before do
        login_as_user(first_user)
      end

      specify 'creates new report' do
        expect do
          post :create, report: valid_report_attributes
        end.to change(Report, :count).by(1)
      end
    end
  end

  describe '#edit' do
    context 'logged as admin' do
      before do
        login_as_user(admin)
      end

      specify 'shows form for any draft report' do
        get :edit, id: draft_report.to_param

        expect(response).to be_success
      end

      specify 'not allowing to edit reported report' do
        get :edit, id: reported_report.to_param

        expect(flash[:alert]).to eq('Выполнение данного действия запрещено')
        expect(response).to redirect_to(root_path)
      end
    end

    context 'logged as user' do
      before do
        login_as_user(first_user)
      end

      specify 'shows form self draft report' do
        get :edit, id: draft_report.to_param

        expect(response).to be_success
      end

      specify 'don\'t show form for another user\'s report' do
        get :edit, id: draft_report2.to_param

        expect(flash[:alert]).to eq('Выполнение данного действия запрещено')
        expect(response).to be_redirect
      end
    end
  end

  describe '#update' do
    context 'logged as admin' do
      before do
        login_as_user(admin)
      end

      # TODO: extract to shared examples
      specify 'updates with valid params draft report' do
        put :update, id: draft_report.to_param, report: { title: 'Updated title' }

        draft_report.reload
        expect(response).to redirect_to(report_path(draft_report))
        expect(draft_report.title).to eq('Updated title')
      end

      specify 'not update with invalid params' do
        expect do
          put :update, id: draft_report.to_param, report: { title: '' }
        end.not_to change(draft_report, :title)
      end

      specify 'not update reported report' do
        expect do
          put :update, id: reported_report.to_param, report: { title: 'valid title' }
        end.not_to change(reported_report, :title)
      end
    end

    context 'logged as user' do
      before do
        login_as_user(first_user)
      end

      specify 'not update with invalid params' do
        expect do
          put :update, id: draft_report.to_param, report: { title: '' }
        end.not_to change(draft_report, :title)
      end

      specify 'not update another user\'s draft report' do
        put :update, id: draft_report2.to_param, report: valid_report_attributes

        expect(flash[:alert]).to eq('Выполнение данного действия запрещено')
        expect(response).to be_redirect
      end
    end
  end

  describe '#destroy' do
    context 'logged as admin' do
      before do
        login_as_user(admin)
      end

      specify 'deletes draft report' do
        expect { delete :destroy, id: draft_report.to_param }
          .to change(Report, :count).by(-1)
      end

      specify 'can\'t destroy reported report' do
        expect { delete :destroy, id: reported_report.to_param }
          .not_to change(Report, :count)
      end
    end

    context 'logged as user' do
      before do
        login_as_user(first_user)
      end

      specify 'deletes own draft report' do
        expect { delete :destroy, id: draft_report.to_param }
          .to change(Report, :count).by(-1)
      end

      specify 'can\'t delete another user\'s draft report' do
        expect { delete :destroy, id: draft_report2.to_param }
          .not_to change(Report, :count)
      end

      specify 'can\'t delete own reported report' do
        expect { delete :destroy, id: reported_report.to_param }
          .not_to change(Report, :count)
      end
    end
  end
end
