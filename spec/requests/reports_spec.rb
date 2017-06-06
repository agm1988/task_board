# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Reports', type: :request do
  let!(:admin) { create(:user, :admin) }

  before do
    sign_in(admin)
  end

  describe 'GET /reports' do
    it 'works!' do
      get reports_path
      expect(response).to have_http_status(200)
    end
  end
end
