# frozen_string_literal: true

require 'rails_helper'

RSpec.describe TagsController, type: :controller do
  let!(:admin) { create(:user, :admin) }
  let!(:user) { create(:user) }

  let!(:first_tag) { create(:tag) }
  let!(:second_tag) { create(:tag) }

  describe '#index' do
    context 'logged as admin' do
      before do
        login_as_user(admin)

        get :index
      end

      it 'returns a success response' do
        expect(response).to be_success
        expect(assigns(:tags)).to match_array([first_tag, second_tag])
      end
    end

    context 'logged as user' do
      before do
        login_as_user(user)

        get :index
      end

      it 'returns a success response' do
        expect(response).to be_success
        expect(assigns(:tags)).to match_array([first_tag, second_tag])
      end
    end
  end

  describe '#show' do
    context 'logged as admin' do
      before do
        login_as_user(admin)
      end

      specify 'shows tag' do
        get :show, id: first_tag.id

        expect(response).to be_success
        expect(assigns(:tag)).to eq(first_tag)
      end
    end

    context 'logged as user' do
      before do
        login_as_user(user)
      end

      specify 'shows tag' do
        get :show, id: first_tag.id

        expect(response).to be_success
        expect(assigns(:tag)).to eq(first_tag)
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
        login_as_user(user)
      end

      specify 'redirects to root' do
        get :new

        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe '#create' do
    context 'logged as admin' do
      before do
        login_as_user(admin)
      end

      specify 'creates new tag' do
        expect do
          post :create, tag: attributes_for(:tag)
        end.to change(Tag, :count).by(1)
      end

      context 'tag is not created' do
        specify 'not creating a record with invalid params' do
          expect do
            post :create, tag: { name: '' }
          end.not_to change(Tag, :count)
        end

        specify 'renders new template' do
          post :create, tag: { name: '' }

          expect(response).to render_template(:new)
        end
      end
    end

    context 'logged as user' do
      before do
        login_as_user(user)
      end

      specify 'not creates a tag' do
        expect do
          post :create, tag: attributes_for(:tag)
        end.not_to change(Tag, :count)
      end
    end
  end

  describe '#edit' do
    context 'logged as admin' do
      before do
        login_as_user(admin)
      end

      specify 'shows form' do
        get :edit, id: first_tag.to_param

        expect(response).to be_success
      end
    end

    context 'logged as user' do
      before do
        login_as_user(user)
      end

      specify 'dont show form' do
        get :edit, id: first_tag.to_param

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
        put :update, id: first_tag.to_param, tag: { name: 'Bond 007' }

        first_tag.reload
        expect(response).to redirect_to(tag_path(first_tag))
        expect(first_tag.name).to eq('Bond 007')
      end

      specify 'not update with invalid params' do
        expect do
          put :update, id: first_tag.to_param, tag: { name: '' }
        end.not_to change(first_tag, :name)
      end
    end

    context 'logged as user' do
      before do
        login_as_user(user)
      end

      specify 'not allow to update' do
        expect do
          put :update, id: first_tag.to_param, tag: { name: 'valid' }
        end.not_to change(first_tag, :name)
      end
    end
  end

  describe '#destroy' do
    context 'logged as admin' do
      before do
        login_as_user(admin)
      end

      specify 'deletes tag' do
        expect { delete :destroy, id: second_tag.to_param }
          .to change(Tag, :count).by(-1)
      end
    end

    context 'logged as user' do
      before do
        login_as_user(user)
      end

      specify 'can\'t delete tag' do
        expect { delete :destroy, id: second_tag.to_param }
          .not_to change(Tag, :count)
      end
    end
  end
end
