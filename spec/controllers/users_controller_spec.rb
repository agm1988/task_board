# frozen_string_literal: true

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  let!(:admin) { create(:user, :admin) }
  let!(:first_user) { create(:user) }
  let!(:second_user) { create(:user) }

  describe '#index' do
    context 'logged as admin' do
      before do
        login_as_user(admin)

        get :index
      end

      it 'returns a success response' do
        expect(response).to be_success
        expect(assigns(:users)).to match_array([admin, first_user, second_user])
      end
    end

    context 'logged as user' do
      before do
        login_as_user(first_user)

        get :index
      end

      it 'returns a success response' do
        expect(response).to be_success
        expect(assigns(:users)).to match_array([first_user])
      end
    end
  end

  describe '#show' do
    context 'logged as admin' do
      before do
        login_as_user(admin)
      end

      specify 'shows own record' do
        get :show, id: admin.id

        expect(response).to be_success
        expect(assigns(:user)).to eq(admin)
      end

      specify 'shows user\'s record' do
        get :show, id: first_user.id

        expect(response).to be_success
        expect(assigns(:user)).to eq(first_user)
      end
    end

    context 'logged as user' do
      before do
        login_as_user(first_user)
      end

      specify 'shows own record' do
        get :show, id: first_user.id

        expect(response).to be_success
        expect(assigns(:user)).to eq(first_user)
      end

      specify 'not showing another user\'s record' do
        get :show, id: second_user.id

        expect(response).to be_redirect
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

      specify 'redirects to users list' do
        get :new

        expect(response).to be_redirect
      end
    end
  end

  describe '#create' do
    context 'logged as admin' do
      before do
        login_as_user(admin)
      end

      specify 'creates new user' do
        expect do
          post :create, user: attributes_for(:user)
        end.to change(User, :count).by(1)
      end

      context 'user is not created' do
        specify 'not creating a record with invalid params' do
          expect do
            post :create, user: { first_name: 'James', last_name: 'Bond' }
          end.not_to change(User, :count)
        end

        specify 'renders new template' do
          post :create, user: { first_name: 'James', last_name: 'Bond' }

          expect(response).to render_template(:new)
        end
      end
    end

    context 'logged as user' do
      before do
        login_as_user(first_user)
      end

      specify 'redirects to users list' do
        expect do
          post :create, user: attributes_for(:user)
        end.not_to change(User, :count)
      end
    end
  end

  describe '#edit' do
    context 'logged as admin' do
      before do
        login_as_user(admin)
      end

      specify 'shows form for self' do
        get :edit, id: admin.to_param

        expect(response).to be_success
      end

      specify 'shows form for another user' do
        get :edit, id: admin.to_param

        expect(response).to be_success
      end
    end

    context 'logged as user' do
      before do
        login_as_user(first_user)
      end

      specify 'shows form for self' do
        get :edit, id: first_user.to_param

        expect(response).to be_success
      end

      specify 'dont show form for another user' do
        get :edit, id: admin.to_param

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
      specify 'updates with valid params' do
        put :update, id: admin.to_param, user: { last_name: 'Bond 007' }

        admin.reload
        expect(response).to redirect_to(user_path(admin))
        expect(admin.last_name).to eq('Bond 007')
      end

      specify 'not update with invalid params' do
        put :update, id: admin.to_param, user: { last_name: '' }

        admin.reload
        expect(response).to render_template(:edit)
        expect(admin.last_name).not_to eq('')
      end

      specify 'not update with invalid params' do
        expect do
          put :update, id: admin.to_param, user: { last_name: '' }
        end.not_to change(admin, :last_name)
      end
    end

    context 'logged as user' do
      before do
        login_as_user(first_user)
      end

      specify 'updates with valid params' do
        put :update, id: first_user.to_param, user: { last_name: 'Bond 007' }

        first_user.reload
        expect(response).to redirect_to(user_path(first_user))
        expect(first_user.last_name).to eq('Bond 007')
      end

      specify 'not update with invalid params' do
        put :update, id: first_user.to_param, user: { last_name: '' }

        first_user.reload
        expect(response).to render_template(:edit)
        expect(first_user.last_name).not_to eq('')
      end
    end
  end

  describe '#destroy' do
    context 'logged as admin' do
      before do
        login_as_user(admin)
      end

      specify 'deletes user' do
        expect { delete :destroy, id: second_user.to_param }
          .to change(User, :count).by(-1)
      end

      specify 'can\'t destroy self' do
        expect { delete :destroy, id: admin.to_param }
          .not_to change(User, :count)
      end
    end

    context 'logged as user' do
      before do
        login_as_user(first_user)
      end

      specify 'can\'t delete user' do
        expect { delete :destroy, id: second_user.to_param }
          .not_to change(User, :count)
      end
    end
  end
end
