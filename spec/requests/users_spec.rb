# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Users', type: :request do
  let!(:admin) { create(:user, :admin) }

  before do
    sign_in(admin)
  end

  describe 'GET /users' do
    it 'works!' do
      get users_path
      expect(response).to have_http_status(200)
    end
  end
end
